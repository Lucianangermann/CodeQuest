import { useState, useEffect, useRef } from 'react'
import { useParams, useNavigate } from 'react-router-dom'
import { motion, AnimatePresence } from 'framer-motion'
import { useQuery, useQueryClient } from '@tanstack/react-query'
import { ArrowLeft, CheckCircle, XCircle, Loader2, ChevronRight, HelpCircle, Sparkles } from 'lucide-react'
import ReactMarkdown from 'react-markdown'
import remarkGfm from 'remark-gfm'
import { Prism as SyntaxHighlighter } from 'react-syntax-highlighter'
import { vscDarkPlus } from 'react-syntax-highlighter/dist/esm/styles/prism'
import { fetchLesson, submitLesson, explainMistake, getCodeReview } from '../lib/api'
import { useLessonStore } from '../store/useLessonStore'
import { useUserStore } from '../store/useUserStore'
import { useT } from '../i18n/useT'
import type { Lesson, QuizContent, CodeContent, TheoryContent } from '../types'
import Editor from '../components/Editor'
import HintSystem from '../components/HintSystem'
import toast from 'react-hot-toast'

// ── Theory ────────────────────────────────────────────────────────────────────

function TheoryView({ content }: { content: TheoryContent }) {
  return (
    <div className="space-y-4">
      {content.sections.map((section, i) => (
        <div key={i}>
          {section.type === 'text' ? (
            <div className="
              prose prose-invert prose-sm max-w-none
              prose-headings:text-white prose-headings:font-bold
              prose-strong:text-white
              prose-code:text-quest-purple-light prose-code:bg-quest-border prose-code:rounded prose-code:px-1 prose-code:py-0.5 prose-code:text-sm prose-code:before:content-none prose-code:after:content-none
              prose-ul:text-quest-text prose-li:text-quest-text prose-p:text-quest-text
            ">
              <ReactMarkdown remarkPlugins={[remarkGfm]}>{section.content}</ReactMarkdown>
            </div>
          ) : (
            <div className="rounded-xl overflow-hidden border border-quest-border">
              <div className="flex items-center gap-2 px-4 py-2 bg-[#1e1e2e] border-b border-quest-border text-xs text-quest-muted font-mono">
                {section.language || 'python'}
              </div>
              <SyntaxHighlighter
                language={section.language || 'python'}
                style={vscDarkPlus}
                customStyle={{ margin: 0, background: '#0d0d1a', fontSize: '13px', padding: '16px' }}
              >
                {section.content}
              </SyntaxHighlighter>
            </div>
          )}
        </div>
      ))}
      {content.summary && (
        <div className="mt-2 p-4 rounded-xl bg-quest-purple/10 border border-quest-purple/20 text-sm text-quest-text">
          <strong className="text-quest-purple-light">Summary:</strong> {content.summary}
        </div>
      )}
    </div>
  )
}

// ── Quiz ──────────────────────────────────────────────────────────────────────

function QuizView({ content, onSubmit, isSubmitting }: {
  content: QuizContent; onSubmit: (answer: string) => void; isSubmitting: boolean
}) {
  const [selected, setSelected] = useState<number | null>(null)
  const t = useT()

  return (
    <div className="space-y-6">
      <p className="text-lg font-medium text-white leading-relaxed">{content.question}</p>
      <div className="space-y-3">
        {content.options.map((option, i) => (
          <motion.button
            key={i}
            whileHover={{ x: 4 }}
            onClick={() => setSelected(i)}
            className={`w-full text-left px-4 py-3 rounded-xl border-2 transition-all text-sm ${
              selected === i
                ? 'border-quest-purple bg-quest-purple/10 text-white'
                : 'border-quest-border bg-quest-card text-quest-text hover:border-quest-purple/40'
            }`}
          >
            <span className="font-mono mr-3 text-quest-muted">{['A', 'B', 'C', 'D'][i]}.</span>
            {option}
          </motion.button>
        ))}
      </div>
      <button
        onClick={() => selected !== null && onSubmit(String(selected))}
        disabled={selected === null || isSubmitting}
        className="btn-primary flex items-center gap-2"
      >
        {isSubmitting && <Loader2 className="w-4 h-4 animate-spin" />}
        {t('lesson.checkAnswer')}
      </button>
    </div>
  )
}

// ── Code ──────────────────────────────────────────────────────────────────────

function CodeView({ content, lessonId, language, onSubmit, isSubmitting, conceptIntro }: {
  content: CodeContent; lessonId: number; language: string
  onSubmit: (code: string) => void; isSubmitting: boolean; conceptIntro?: string | null
}) {
  const [code, setCode] = useState(content.starter_code)
  const [isExplaining, setIsExplaining] = useState(false)
  const [explanation, setExplanation] = useState('')
  const [showIntro, setShowIntro] = useState(true)
  const t = useT()

  async function handleExplain() {
    setIsExplaining(true)
    try {
      const text = await explainMistake(lessonId, code, 'Output did not match expected')
      setExplanation(text)
    } catch {
      toast.error('Could not get explanation')
    } finally {
      setIsExplaining(false)
    }
  }

  return (
    <div className="space-y-4">
      {conceptIntro && (
        <div className="p-4 bg-amber-500/10 border border-amber-500/20 rounded-xl">
          <button
            onClick={() => setShowIntro(s => !s)}
            className="flex items-center gap-2 w-full text-left"
          >
            <span className="text-amber-400 font-semibold text-sm">💡 Konzept-Erinnerung</span>
            <ChevronRight className={`w-4 h-4 text-amber-400 ml-auto transition-transform duration-200 ${showIntro ? 'rotate-90' : ''}`} />
          </button>
          {showIntro && (
            <p className="text-quest-text text-sm mt-2 leading-relaxed">{conceptIntro}</p>
          )}
        </div>
      )}
      <div className="p-4 bg-quest-purple/10 border border-quest-purple/20 rounded-xl">
        <h3 className="font-semibold text-quest-purple-light mb-2">Task</h3>
        <p className="text-quest-text text-sm leading-relaxed whitespace-pre-line">{content.instructions}</p>
      </div>

      <Editor
        value={code}
        onChange={setCode}
        language={language}
        height="200px"
        onCtrlEnter={onSubmit}
      />

      <HintSystem
        lessonId={lessonId}
        userCode={code}
        staticHints={(content as CodeContent).hints || []}
      />

      <button onClick={() => onSubmit(code)} disabled={isSubmitting} className="btn-primary flex items-center gap-2">
        {isSubmitting && <Loader2 className="w-4 h-4 animate-spin" />}
        {t('lesson.submitCode')}
      </button>

      {explanation ? (
        <motion.div
          initial={{ opacity: 0, y: 8 }}
          animate={{ opacity: 1, y: 0 }}
          className="p-4 bg-blue-500/10 border border-blue-500/20 rounded-xl text-sm text-quest-text leading-relaxed"
        >
          <p className="font-semibold text-blue-400 mb-1">AI Explanation</p>
          {explanation}
        </motion.div>
      ) : (
        <button
          onClick={handleExplain}
          disabled={isExplaining}
          className="text-sm text-quest-muted hover:text-quest-text flex items-center gap-1 transition-colors"
        >
          {isExplaining ? <Loader2 className="w-3 h-3 animate-spin" /> : <HelpCircle className="w-3 h-3" />}
          Explain my mistake
        </button>
      )}
    </div>
  )
}

// ── Page ──────────────────────────────────────────────────────────────────────

export default function LessonPage() {
  const { lessonId } = useParams<{ lessonId: string }>()
  const navigate = useNavigate()
  const { currentLesson, currentTopicName, setCurrentLesson, startLesson } = useLessonStore()
  const { user, updateXP } = useUserStore()
  const t = useT()
  const queryClient = useQueryClient()

  const [isSubmitting, setIsSubmitting] = useState(false)
  const [result, setResult] = useState<{
    correct: boolean; feedback: string; xp_earned: number;
    output?: string; error?: string; topic_completed?: boolean;
    expected_output?: string; level?: number;
    test_results?: Array<{ description: string; passed: boolean; expected: string; actual: string; error?: string }>
  } | null>(null)
  const [levelUp, setLevelUp] = useState<number | null>(null)
  const [topicComplete, setTopicComplete] = useState(false)
  const [lastSubmittedCode, setLastSubmittedCode] = useState<string>('')
  const [review, setReview] = useState<{
    strengths: string[]; suggestion: string; alternative: string | null; grade: string
  } | null>(null)
  const [reviewLoading, setReviewLoading] = useState(false)
  const [errorExplanation, setErrorExplanation] = useState<string>('')
  const [isExplainingError, setIsExplainingError] = useState(false)
  const [showSolution, setShowSolution] = useState(false)

  const confettiRef = useRef<HTMLCanvasElement>(null)

  const NOTES_KEY = `cq_note_${lessonId}`
  const [note, setNote] = useState(() => localStorage.getItem(NOTES_KEY) || '')
  const [noteSaved, setNoteSaved] = useState(false)

  function saveNote() {
    localStorage.setItem(NOTES_KEY, note)
    setNoteSaved(true)
    setTimeout(() => setNoteSaved(false), 2000)
  }

  // Fetch if navigating directly (no lesson in store, or different lesson)
  const { data: fetchedLesson, isLoading } = useQuery({
    queryKey: ['lesson', lessonId],
    queryFn: () => fetchLesson(Number(lessonId)),
    enabled: !currentLesson || currentLesson.id !== Number(lessonId),
    initialData: currentLesson?.id === Number(lessonId) ? currentLesson : undefined,
    staleTime: Infinity,
  })

  const lesson: Lesson | undefined = fetchedLesson ?? currentLesson ?? undefined

  useEffect(() => {
    if (fetchedLesson && (!currentLesson || currentLesson.id !== fetchedLesson.id)) {
      setCurrentLesson(fetchedLesson)
    }
    startLesson()
    setReview(null)
    setLastSubmittedCode('')
  }, [fetchedLesson])

  useEffect(() => {
    if (!result?.correct) return
    const canvas = confettiRef.current
    if (!canvas) return
    canvas.width = window.innerWidth
    canvas.height = window.innerHeight
    const ctx = canvas.getContext('2d')!
    const colors = ['#9d5cf6', '#fbbf24', '#34d399', '#60a5fa', '#f87171', '#a78bfa', '#fb923c']
    const particles = Array.from({ length: 90 }, () => ({
      x: Math.random() * canvas.width,
      y: -20 - Math.random() * 120,
      vx: (Math.random() - 0.5) * 7,
      vy: Math.random() * 4 + 2,
      color: colors[Math.floor(Math.random() * colors.length)],
      w: Math.random() * 12 + 4,
      h: Math.random() * 6 + 3,
      rotation: Math.random() * 360,
      rotVel: (Math.random() - 0.5) * 14,
    }))
    let frame = 0
    let rafId: number
    const animate = () => {
      ctx.clearRect(0, 0, canvas.width, canvas.height)
      const alpha = Math.max(0, 1 - frame / 80)
      particles.forEach(p => {
        ctx.save()
        ctx.globalAlpha = alpha
        ctx.translate(p.x, p.y)
        ctx.rotate((p.rotation * Math.PI) / 180)
        ctx.fillStyle = p.color
        ctx.fillRect(-p.w / 2, -p.h / 2, p.w, p.h)
        ctx.restore()
        p.x += p.vx; p.y += p.vy; p.vy += 0.09; p.rotation += p.rotVel
      })
      frame++
      if (frame < 100) rafId = requestAnimationFrame(animate)
      else ctx.clearRect(0, 0, canvas.width, canvas.height)
    }
    animate()
    return () => cancelAnimationFrame(rafId)
  }, [result?.correct])

  if (isLoading || !lesson) {
    return (
      <div className="flex items-center justify-center min-h-[60vh]">
        <Loader2 className="w-8 h-8 animate-spin text-quest-purple" />
      </div>
    )
  }

  async function handleGetReview() {
    if (!lesson) return
    setReviewLoading(true)
    try {
      const r = await getCodeReview(lesson.id, lastSubmittedCode, lesson.language || 'python')
      setReview(r)
    } catch {
      toast.error('Could not load review. Please try again.')
    } finally {
      setReviewLoading(false)
    }
  }

  async function handleExplainError() {
    if (!lesson || !result) return
    setIsExplainingError(true)
    try {
      const text = await explainMistake(lesson.id, lastSubmittedCode, result.error || result.output || 'Fehler')
      setErrorExplanation(text)
    } catch {
      toast.error('Konnte Fehler nicht erklären')
    } finally {
      setIsExplainingError(false)
    }
  }

  async function handleSubmit(answer: string) {
    if (!lesson) return
    setIsSubmitting(true)
    setLastSubmittedCode(answer)
    setErrorExplanation('')
    setShowSolution(false)
    try {
      const res = await submitLesson(lesson.id, answer, lesson.language || 'python')
      setResult({
        correct: res.correct,
        feedback: res.feedback,
        xp_earned: res.xp_earned,
        output: res.output,
        error: res.error,
        topic_completed: res.topic_completed,
        expected_output: res.expected_output,
        level: res.level,
        test_results: res.test_results,
      })
      if (res.correct && res.xp_earned > 0) {
        const newXP = (user?.xp ?? 0) + res.xp_earned
        const newLevel = res.level ?? Math.max(1, Math.floor(newXP / 100))
        updateXP(newXP, newLevel)
        if (newLevel > (user?.level ?? 1)) {
          setLevelUp(newLevel)
          setTimeout(() => setLevelUp(null), 4000)
        }
        toast.success(`+${res.xp_earned} ${t('lesson.xpEarned')} 🎉`)
        queryClient.invalidateQueries({ queryKey: ['topics'] })
        queryClient.invalidateQueries({ queryKey: ['topic-lessons', lesson.topic_id] })
        queryClient.invalidateQueries({ queryKey: ['dashboard'] })
        if (res.topic_completed) {
          setTimeout(() => setTopicComplete(true), 800)
        }
      }
    } catch {
      toast.error('Submission failed. Please try again.')
    } finally {
      setIsSubmitting(false)
    }
  }

  const typeBadge = {
    theory: { label: '📖 Theory', cls: 'bg-blue-500/20 text-blue-400' },
    quiz:   { label: '🧠 Quiz',   cls: 'bg-quest-yellow/20 text-quest-yellow' },
    code:   { label: '💻 Code',   cls: 'bg-quest-purple/20 text-quest-purple-light' },
  }[lesson.type]

  function downloadCertificate() {
    const canvas = document.createElement('canvas')
    canvas.width = 900
    canvas.height = 600
    const ctx = canvas.getContext('2d')!
    // Background
    ctx.fillStyle = '#0f0f1a'
    ctx.fillRect(0, 0, 900, 600)
    // Outer border
    ctx.strokeStyle = '#7c3aed'
    ctx.lineWidth = 8
    ctx.strokeRect(20, 20, 860, 560)
    // Inner border
    ctx.strokeStyle = '#6366f1'
    ctx.lineWidth = 2
    ctx.strokeRect(35, 35, 830, 530)
    // Title
    ctx.fillStyle = '#9d5cf6'
    ctx.font = 'bold 20px sans-serif'
    ctx.textAlign = 'center'
    ctx.fillText('⚡ CodeQuest', 450, 90)
    ctx.fillStyle = '#ffffff'
    ctx.font = 'bold 52px sans-serif'
    ctx.fillText('ZERTIFIKAT', 450, 155)
    // Decorative line
    ctx.strokeStyle = '#7c3aed'
    ctx.lineWidth = 2
    ctx.beginPath(); ctx.moveTo(150, 175); ctx.lineTo(750, 175); ctx.stroke()
    // Body text
    ctx.fillStyle = '#94a3b8'
    ctx.font = '22px sans-serif'
    ctx.fillText('Hiermit wird bestätigt, dass', 450, 230)
    ctx.fillStyle = '#ffffff'
    ctx.font = 'bold 38px sans-serif'
    ctx.fillText(user?.username || 'Lernender', 450, 285)
    ctx.fillStyle = '#94a3b8'
    ctx.font = '22px sans-serif'
    ctx.fillText('das Thema erfolgreich abgeschlossen hat:', 450, 335)
    ctx.fillStyle = '#fbbf24'
    ctx.font = 'bold 34px sans-serif'
    ctx.fillText(currentTopicName || 'Programmieren', 450, 395)
    // Date
    ctx.strokeStyle = '#7c3aed'
    ctx.lineWidth = 1
    ctx.beginPath(); ctx.moveTo(150, 430); ctx.lineTo(750, 430); ctx.stroke()
    ctx.fillStyle = '#64748b'
    ctx.font = '16px sans-serif'
    ctx.fillText(new Date().toLocaleDateString('de-DE', { year: 'numeric', month: 'long', day: 'numeric' }), 450, 460)
    ctx.fillStyle = '#fbbf24'
    ctx.font = '48px sans-serif'
    ctx.fillText('🏆', 450, 530)

    const link = document.createElement('a')
    link.download = `CodeQuest-Zertifikat-${(currentTopicName || 'Topic').replace(/\s+/g, '-')}.png`
    link.href = canvas.toDataURL('image/png')
    link.click()
  }

  return (
    <>
    <canvas
      ref={confettiRef}
      className="fixed inset-0 pointer-events-none z-30"
      style={{ width: '100vw', height: '100vh' }}
    />
    {/* Level-Up Overlay */}
    <AnimatePresence>
      {levelUp !== null && (
        <motion.div
          initial={{ opacity: 0 }}
          animate={{ opacity: 1 }}
          exit={{ opacity: 0 }}
          className="fixed inset-0 z-50 flex items-center justify-center bg-black/80 backdrop-blur-sm"
        >
          <motion.div
            initial={{ scale: 0.5, opacity: 0 }}
            animate={{ scale: 1, opacity: 1 }}
            exit={{ scale: 0.8, opacity: 0 }}
            transition={{ type: 'spring', stiffness: 300, damping: 20 }}
            className="flex flex-col items-center gap-4 text-center px-8 py-10 rounded-2xl bg-quest-card border border-quest-purple/40 shadow-2xl max-w-sm w-full mx-4"
          >
            <span className="text-7xl">⚡</span>
            <h2 className="text-4xl font-extrabold bg-gradient-to-r from-quest-purple-light to-quest-yellow bg-clip-text text-transparent">
              {t('lesson.levelUp')}
            </h2>
            <p className="text-quest-text text-lg">{t('lesson.levelUpDesc')} {levelUp}</p>
            <button
              onClick={() => setLevelUp(null)}
              className="btn-primary mt-2 px-8"
            >
              Continue
            </button>
          </motion.div>
        </motion.div>
      )}
    </AnimatePresence>

    {/* Topic Completion Overlay */}
    <AnimatePresence>
      {topicComplete && (
        <motion.div
          initial={{ opacity: 0 }}
          animate={{ opacity: 1 }}
          exit={{ opacity: 0 }}
          className="fixed inset-0 z-50 flex items-center justify-center bg-black/80 backdrop-blur-sm"
          onClick={() => setTopicComplete(false)}
        >
          <motion.div
            initial={{ scale: 0.5, opacity: 0 }}
            animate={{ scale: 1, opacity: 1 }}
            exit={{ scale: 0.8, opacity: 0 }}
            transition={{ type: 'spring', stiffness: 300, damping: 20 }}
            className="flex flex-col items-center gap-4 text-center px-8 py-10 rounded-2xl bg-quest-card border border-quest-yellow/40 shadow-2xl max-w-sm w-full mx-4"
            onClick={(e) => e.stopPropagation()}
          >
            <span className="text-7xl">🏆</span>
            <h2 className="text-4xl font-extrabold bg-gradient-to-r from-quest-yellow to-orange-400 bg-clip-text text-transparent">
              {t('lesson.topicComplete')}
            </h2>
            <p className="text-quest-text text-lg">{t('lesson.topicCompleteDesc')}</p>
            <p className="text-quest-muted text-sm">Keep going — the next topic awaits.</p>
            <div className="flex gap-3 mt-2">
              <button onClick={() => { setTopicComplete(false); navigate('/roadmap') }} className="btn-primary px-6">
                {t('lesson.nextTopic')}
              </button>
              <button onClick={() => setTopicComplete(false)} className="btn-secondary px-6">
                {t('lesson.stayHere')}
              </button>
              <button
                onClick={downloadCertificate}
                className="btn-secondary px-6 flex items-center gap-2"
              >
                📥 Zertifikat
              </button>
            </div>
          </motion.div>
        </motion.div>
      )}
    </AnimatePresence>

    <motion.div
      initial={{ opacity: 0, y: 12 }}
      animate={{ opacity: 1, y: 0 }}
      transition={{ duration: 0.3 }}
      className="max-w-3xl mx-auto px-4 sm:px-6 py-8"
    >
      {/* Header */}
      <div className="flex items-center gap-3 mb-6">
        <button
          onClick={() => navigate('/roadmap')}
          className="p-2 rounded-xl hover:bg-quest-card transition-colors text-quest-muted hover:text-quest-text"
        >
          <ArrowLeft className="w-5 h-5" />
        </button>
        <div>
          {currentTopicName && <p className="text-xs text-quest-muted">{currentTopicName}</p>}
          <h1 className="text-xl font-bold text-white">{lesson.title}</h1>
        </div>
        <span className={`ml-auto badge-pill text-xs ${typeBadge.cls}`}>{typeBadge.label}</span>
      </div>

      {/* Content */}
      <div className="card">
        <AnimatePresence mode="wait">
          {(!result || !result.correct) && (
            <motion.div key="lesson" initial={{ opacity: 0 }} animate={{ opacity: 1 }} exit={{ opacity: 0 }}>
              {lesson.type === 'theory' && (
                <>
                  <TheoryView content={lesson.content_json as TheoryContent} />
                  <div className="mt-6 pt-6 border-t border-quest-border">
                    <button onClick={() => handleSubmit('read')} disabled={isSubmitting} className="btn-primary flex items-center gap-2">
                      {isSubmitting ? <Loader2 className="w-4 h-4 animate-spin" /> : <CheckCircle className="w-4 h-4" />}
                      {t('lesson.markRead')} (+{lesson.xp_reward} XP)
                    </button>
                  </div>
                </>
              )}
              {lesson.type === 'quiz' && (
                <QuizView content={lesson.content_json as QuizContent} onSubmit={handleSubmit} isSubmitting={isSubmitting} />
              )}
              {lesson.type === 'code' && (
                <CodeView
                  content={lesson.content_json as CodeContent}
                  lessonId={lesson.id}
                  language={lesson.language || 'python'}
                  onSubmit={handleSubmit}
                  isSubmitting={isSubmitting}
                  conceptIntro={lesson.concept_intro}
                />
              )}
            </motion.div>
          )}
        </AnimatePresence>

        {/* Result */}
        {result && (
          <motion.div
            initial={{ opacity: 0, y: 12 }}
            animate={{ opacity: 1, y: 0 }}
            className={`mt-6 p-4 rounded-xl border ${
              result.correct ? 'bg-quest-green/10 border-quest-green/30' : 'bg-red-500/10 border-red-500/30'
            }`}
          >
            <div className="flex items-start gap-3">
              {result.correct
                ? <CheckCircle className="w-5 h-5 text-quest-green flex-shrink-0 mt-0.5" />
                : <XCircle className="w-5 h-5 text-red-400 flex-shrink-0 mt-0.5" />}
              <div className="flex-1">
                <p className={`font-semibold ${result.correct ? 'text-quest-green' : 'text-red-400'}`}>
                  {result.correct ? `${t('lesson.correct')} 🎉` : t('lesson.incorrect')}
                </p>
                {/* For code lessons with diff data, show a short message; otherwise show full feedback */}
                {lesson.type === 'code' && !result.correct && result.expected_output
                  ? result.feedback !== 'Not quite right.' && (
                      <p className="text-quest-text text-sm mt-1 whitespace-pre-wrap">{result.feedback}</p>
                    )
                  : <p className="text-quest-text text-sm mt-1 whitespace-pre-wrap">{result.feedback}</p>
                }
                {result.xp_earned > 0 && (
                  <p className="text-xs font-medium text-quest-green mt-2">+{result.xp_earned} {t('lesson.xpEarned')}</p>
                )}

                {/* AI Code Review section */}
                {result.correct && lesson.type === 'code' && !review && (
                  <button
                    onClick={handleGetReview}
                    disabled={reviewLoading}
                    className="mt-3 flex items-center gap-2 text-sm px-4 py-2 rounded-xl border border-quest-purple/40 text-quest-purple-light hover:bg-quest-purple/10 transition-all disabled:opacity-50"
                  >
                    {reviewLoading
                      ? <><Loader2 className="w-4 h-4 animate-spin" /> Analyzing your code...</>
                      : <><Sparkles className="w-4 h-4" /> {t('lesson.getAiReview')}</>
                    }
                  </button>
                )}

                {review && (
                  <motion.div
                    initial={{ opacity: 0, y: 8 }}
                    animate={{ opacity: 1, y: 0 }}
                    className="mt-4 rounded-xl border border-quest-purple/30 overflow-hidden"
                  >
                    {/* Header */}
                    <div className="px-4 py-3 flex items-center justify-between"
                      style={{ background: 'linear-gradient(135deg, rgba(124,58,237,0.15) 0%, rgba(99,102,241,0.1) 100%)' }}>
                      <div className="flex items-center gap-2">
                        <Sparkles className="w-4 h-4 text-quest-purple-light" />
                        <span className="font-semibold text-sm text-white">{t('lesson.aiReview')}</span>
                      </div>
                      <span className={`text-xs font-bold px-2 py-0.5 rounded-full ${
                        review.grade === 'Excellent' ? 'bg-quest-green/20 text-quest-green' :
                        review.grade === 'Great' ? 'bg-blue-400/20 text-blue-400' :
                        'bg-quest-yellow/20 text-quest-yellow'
                      }`}>
                        {review.grade}
                      </span>
                    </div>

                    <div className="p-4 space-y-3">
                      {/* Strengths */}
                      <div>
                        <p className="text-xs font-semibold text-quest-green uppercase tracking-wider mb-1.5">{t('lesson.aiStrengths')}</p>
                        <ul className="space-y-1">
                          {review.strengths.map((s, i) => (
                            <li key={i} className="flex items-start gap-2 text-sm text-quest-text">
                              <CheckCircle className="w-3.5 h-3.5 text-quest-green flex-shrink-0 mt-0.5" />
                              {s}
                            </li>
                          ))}
                        </ul>
                      </div>

                      {/* Suggestion */}
                      <div>
                        <p className="text-xs font-semibold text-quest-yellow uppercase tracking-wider mb-1.5">{t('lesson.aiSuggestion')}</p>
                        <p className="text-sm text-quest-text">{review.suggestion}</p>
                      </div>

                      {/* Alternative */}
                      {review.alternative && (
                        <div>
                          <p className="text-xs font-semibold text-quest-purple-light uppercase tracking-wider mb-1.5">{t('lesson.aiAlternative')}</p>
                          <pre className="text-xs text-quest-text bg-black/30 rounded-lg p-3 overflow-x-auto font-mono border border-quest-border/50">
                            {review.alternative}
                          </pre>
                        </div>
                      )}
                    </div>
                  </motion.div>
                )}

                {/* Feature 1: Error Explainer */}
                {!result.correct && lesson.type === 'code' && (
                  <div className="mt-3">
                    {!errorExplanation ? (
                      <button
                        onClick={handleExplainError}
                        disabled={isExplainingError}
                        className="flex items-center gap-2 text-sm px-4 py-2 rounded-xl border border-red-400/30 text-red-300 hover:bg-red-400/10 transition-all disabled:opacity-50"
                      >
                        {isExplainingError
                          ? <><Loader2 className="w-4 h-4 animate-spin" /> Analysiere Fehler...</>
                          : <><HelpCircle className="w-4 h-4" /> 🔍 Fehler erklären (Deutsch)</>}
                      </button>
                    ) : (
                      <motion.div
                        initial={{ opacity: 0, y: 8 }}
                        animate={{ opacity: 1, y: 0 }}
                        className="p-4 bg-blue-500/10 border border-blue-500/20 rounded-xl text-sm text-quest-text leading-relaxed"
                      >
                        <p className="font-semibold text-blue-400 mb-2">🔍 Fehler-Erklärung</p>
                        <p>{errorExplanation}</p>
                        <button
                          onClick={() => setErrorExplanation('')}
                          className="mt-2 text-xs text-quest-muted hover:text-quest-text transition-colors"
                        >
                          Schließen
                        </button>
                      </motion.div>
                    )}
                  </div>
                )}

                {/* Feature 2: Solution Comparison */}
                {result.correct && lesson.type === 'code' && (lesson.content_json as CodeContent).solution && (
                  <div className="mt-3">
                    <button
                      onClick={() => setShowSolution(s => !s)}
                      className="flex items-center gap-2 text-sm px-4 py-2 rounded-xl border border-quest-green/30 text-quest-green hover:bg-quest-green/10 transition-all"
                    >
                      📖 {showSolution ? 'Musterlösung verbergen' : 'Musterlösung ansehen'}
                    </button>
                    {showSolution && (
                      <motion.div
                        initial={{ opacity: 0, y: 8 }}
                        animate={{ opacity: 1, y: 0 }}
                        className="mt-3 rounded-xl overflow-hidden border border-quest-green/30"
                      >
                        <div className="px-4 py-2 bg-quest-green/10 border-b border-quest-green/20">
                          <p className="text-xs font-semibold text-quest-green uppercase tracking-wider">Musterlösung</p>
                        </div>
                        <Editor
                          value={(lesson.content_json as CodeContent).solution!}
                          onChange={() => {}}
                          language={lesson.language || 'python'}
                          readOnly
                          height="180px"
                        />
                        <div className="px-4 py-3 bg-black/20 border-t border-quest-border/30">
                          <p className="text-xs text-quest-muted">Vergleiche deine Lösung mit der Musterlösung. Gibt es elegantere Wege?</p>
                        </div>
                      </motion.div>
                    )}
                  </div>
                )}

                {/* Test case results panel */}
                {result?.test_results && result.test_results.length > 0 && (
                  <div className="mt-4 space-y-2">
                    <h3 className="text-sm font-semibold text-quest-muted">Test Results</h3>
                    {result.test_results.map((tc, i) => (
                      <div
                        key={i}
                        className={`rounded-xl p-3 border text-sm ${
                          tc.passed
                            ? 'bg-quest-green/10 border-quest-green/30'
                            : 'bg-red-500/10 border-red-500/30'
                        }`}
                      >
                        <div className="flex items-center gap-2 font-medium">
                          <span>{tc.passed ? '✓' : '✗'}</span>
                          <span className={tc.passed ? 'text-quest-green' : 'text-red-400'}>
                            {tc.description}
                          </span>
                        </div>
                        {!tc.passed && (
                          <div className="mt-2 grid grid-cols-2 gap-2 text-xs font-mono">
                            <div>
                              <div className="text-quest-muted mb-1">Expected</div>
                              <div className="bg-quest-bg/50 rounded p-2 text-quest-green whitespace-pre-wrap">
                                {tc.expected}
                              </div>
                            </div>
                            <div>
                              <div className="text-quest-muted mb-1">Got</div>
                              <div className="bg-quest-bg/50 rounded p-2 text-red-400 whitespace-pre-wrap">
                                {tc.error || tc.actual || '(no output)'}
                              </div>
                            </div>
                          </div>
                        )}
                      </div>
                    ))}
                  </div>
                )}

                {/* Diff view for wrong code output */}
                {lesson.type === 'code' && !result.correct && result.expected_output && (
                  <div className="mt-4 rounded-lg overflow-hidden border border-quest-border text-xs font-mono">
                    <div className="grid grid-cols-2">
                      <div className="bg-quest-green/10 border-r border-quest-border p-3">
                        <p className="text-quest-green font-semibold mb-2 text-xs uppercase tracking-wider">{t('lesson.expectedOutput')}</p>
                        {result.expected_output.trim().split('\n').map((line, i) => (
                          <div key={i} className="text-quest-green/80">{line || <span className="opacity-40">(empty)</span>}</div>
                        ))}
                      </div>
                      <div className="bg-red-500/10 p-3">
                        <p className="text-red-400 font-semibold mb-2 text-xs uppercase tracking-wider">{t('lesson.yourOutput')}</p>
                        {result.output
                          ? result.output.trim().split('\n').map((line, i) => {
                              const expLine = result.expected_output!.trim().split('\n')[i]
                              const differs = line !== expLine
                              return (
                                <div key={i} className={differs ? 'text-red-400' : 'text-quest-muted'}>
                                  {line || <span className="opacity-40">(empty)</span>}
                                </div>
                              )
                            })
                          : <span className="text-red-400/50">(no output)</span>
                        }
                      </div>
                    </div>
                  </div>
                )}
              </div>
            </div>

            <div className="flex gap-3 mt-4">
              {!result.correct && (
                <button onClick={() => setResult(null)} className="btn-secondary text-sm">Try Again</button>
              )}
              {result.correct && (
                <button onClick={() => navigate('/roadmap')} className="btn-primary flex items-center gap-2 text-sm">
                  Continue <ChevronRight className="w-4 h-4" />
                </button>
              )}
            </div>
          </motion.div>
        )}

        {/* Personal Notes */}
        <div className="mt-6 pt-6 border-t border-quest-border">
          <p className="text-xs text-quest-muted font-semibold uppercase tracking-wide mb-2">My Notes</p>
          <textarea
            value={note}
            onChange={e => { setNote(e.target.value); setNoteSaved(false) }}
            placeholder="Write notes about this lesson..."
            rows={3}
            className="w-full bg-quest-bg border border-quest-border rounded-xl px-3 py-2 text-sm text-white placeholder-quest-muted focus:outline-none focus:border-quest-purple resize-none"
          />
          <button
            onClick={saveNote}
            className="mt-2 text-xs text-quest-muted hover:text-quest-text transition-colors"
          >
            {noteSaved ? '✓ Saved' : 'Save notes'}
          </button>
        </div>
      </div>
    </motion.div>
    </>
  )
}

import { useState, useRef, useEffect } from 'react'
import { useQuery } from '@tanstack/react-query'
import { motion } from 'framer-motion'
import { Mic, Send, Trophy, AlertCircle, ChevronRight, RotateCcw, History } from 'lucide-react'
import { startInterview, sendInterviewMessage, completeInterview, fetchInterviewHistory, fetchInterviewSession } from '../lib/api'
import type { QAPair, InterviewSummary, InterviewSession } from '../types'
import { useT } from '../i18n/useT'

const TOTAL_QUESTIONS = 10

type Stage = 'setup' | 'active' | 'complete' | 'history'

interface Message { role: 'user' | 'assistant'; content: string }

// ── Setup screen ──────────────────────────────────────────────────────────────

function Setup({ onStart, loading }: { onStart: (company: string, focus: string) => void; loading: boolean }) {
  const t = useT()
  const [company, setCompany] = useState('')
  const [focus, setFocus] = useState('')

  const COMPANY_OPTIONS = [
    { value: 'Startup / Small Company', label: t('ob.coStartup'),  icon: '🚀', desc: t('ob.coStartupDesc') },
    { value: 'Medium Company',          label: t('ob.coMedium'),   icon: '🏢', desc: t('ob.coMediumDesc') },
    { value: 'Large Corporation',       label: t('ob.coLarge'),    icon: '🏦', desc: t('ob.coLargeDesc') },
  ]

  const FOCUS_OPTIONS = [
    { value: 'Frontend',  label: t('ob.focusFrontend'),  icon: '🎨', desc: t('ob.focusFrontendDesc') },
    { value: 'Backend',   label: t('ob.focusBackend'),   icon: '⚙️', desc: t('ob.focusBackendDesc') },
    { value: 'Fullstack', label: t('ob.focusFullstack'), icon: '🔄', desc: t('ob.focusFullstackDesc') },
  ]

  return (
    <div className="max-w-2xl mx-auto px-4 py-12">
      <div className="text-center mb-10">
        <div className="inline-flex items-center justify-center w-16 h-16 bg-violet-500/20 rounded-2xl mb-4">
          <Mic size={28} className="text-violet-400" />
        </div>
        <h1 className="text-3xl font-bold text-white mb-2">{t('iv.title')}</h1>
        <p className="text-gray-400">
          {t('iv.desc')}
        </p>
      </div>

      <div className="space-y-6">
        <div>
          <label className="text-sm font-semibold text-gray-400 uppercase tracking-wide block mb-3">
            {t('iv.targetCompany')}
          </label>
          <div className="space-y-2">
            {COMPANY_OPTIONS.map((c) => (
              <button
                key={c.value}
                onClick={() => setCompany(c.value)}
                className={`w-full flex items-center gap-4 p-4 rounded-xl border-2 text-left transition-all
                  ${company === c.value ? 'border-violet-500 bg-violet-500/10' : 'border-white/10 bg-white/5 hover:border-violet-400/40'}`}
              >
                <span className="text-2xl">{c.icon}</span>
                <div>
                  <div className="font-semibold text-white">{c.label}</div>
                  <div className="text-sm text-gray-400">{c.desc}</div>
                </div>
                {company === c.value && <ChevronRight size={18} className="ml-auto text-violet-400" />}
              </button>
            ))}
          </div>
        </div>

        <div>
          <label className="text-sm font-semibold text-gray-400 uppercase tracking-wide block mb-3">
            {t('iv.focusArea')}
          </label>
          <div className="grid grid-cols-3 gap-2">
            {FOCUS_OPTIONS.map((f) => (
              <button
                key={f.value}
                onClick={() => setFocus(f.value)}
                className={`p-4 rounded-xl border-2 text-center transition-all
                  ${focus === f.value ? 'border-violet-500 bg-violet-500/10' : 'border-white/10 bg-white/5 hover:border-violet-400/40'}`}
              >
                <div className="text-2xl mb-1">{f.icon}</div>
                <div className="font-medium text-white text-sm">{f.label}</div>
                <div className="text-xs text-gray-400 mt-1">{f.desc}</div>
              </button>
            ))}
          </div>
        </div>

        <button
          onClick={() => {
            if (!company || !focus) return
            onStart(company, focus)
          }}
          disabled={!company || !focus || loading}
          className="w-full py-4 bg-violet-600 hover:bg-violet-500 disabled:opacity-40
                     text-white font-semibold text-lg rounded-xl transition-colors"
        >
          {loading ? t('iv.starting') : t('iv.start')}
        </button>
      </div>
    </div>
  )
}

// ── Chat interface ────────────────────────────────────────────────────────────

function InterviewChat({
  sessionId, company, focus, firstQuestion,
  onComplete,
}: {
  sessionId: number
  company: string
  focus: string
  firstQuestion: string
  onComplete: (summary: InterviewSummary) => void
}) {
  const t = useT()
  const [messages, setMessages] = useState<Message[]>([
    { role: 'assistant', content: firstQuestion },
  ])
  const [answer, setAnswer] = useState('')
  const [loading, setLoading] = useState(false)
  const [qNumber, setQNumber] = useState(1)
  const [qaPairs, setQaPairs] = useState<QAPair[]>([])
  const [lastEvaluation, setLastEvaluation] = useState<string | null>(null)
  const [finishing, setFinishing] = useState(false)
  const bottomRef = useRef<HTMLDivElement>(null)

  useEffect(() => {
    bottomRef.current?.scrollIntoView({ behavior: 'smooth' })
  }, [messages, lastEvaluation])

  const handleSubmit = async () => {
    if (!answer.trim() || loading) return

    const userAnswer = answer.trim()
    setAnswer('')
    setLoading(true)
    setLastEvaluation(null)

    const newMessages: Message[] = [...messages, { role: 'user', content: userAnswer }]
    setMessages(newMessages)

    const nextQ = qNumber + 1

    if (nextQ > TOTAL_QUESTIONS) {
      // Final answer — get summary
      const lastPair: QAPair = {
        question: messages[messages.length - 1].content,
        answer: userAnswer,
        evaluation: '',
      }
      const allPairs = [...qaPairs, lastPair]
      setFinishing(true)
      const summary = await completeInterview({
        session_id: sessionId,
        messages: newMessages,
        qa_pairs: allPairs,
        company_size: company,
        focus,
      })
      onComplete(summary)
      return
    }

    try {
      const result = await sendInterviewMessage({
        session_id: sessionId,
        messages: newMessages,
        question_number: nextQ,
        company_size: company,
        focus,
      })

      const pair: QAPair = {
        question: messages[messages.length - 1].content,
        answer: userAnswer,
        evaluation: result.evaluation ?? '',
      }
      setQaPairs((prev) => [...prev, pair])
      setLastEvaluation(result.evaluation)
      setMessages((prev) => [...prev, { role: 'assistant', content: result.question }])
      setQNumber(nextQ)
    } catch {
      setMessages((prev) => [...prev, { role: 'assistant', content: t('iv.connError') }])
    } finally {
      setLoading(false)
    }
  }

  const progress = ((qNumber - 1) / TOTAL_QUESTIONS) * 100

  return (
    <div className="max-w-3xl mx-auto px-4 py-6 flex flex-col h-[calc(100vh-5rem)]">
      {/* Header */}
      <div className="mb-4">
        <div className="flex items-center justify-between mb-2">
          <div className="text-sm text-gray-400">
            <span className="text-white font-medium">{company}</span>
            <span className="mx-2">·</span>
            <span className="text-violet-400">{focus}</span>
          </div>
          <div className="text-sm font-semibold text-white">
            {t('iv.question')} {Math.min(qNumber, TOTAL_QUESTIONS)}/{TOTAL_QUESTIONS}
          </div>
        </div>
        <div className="h-1.5 bg-white/10 rounded-full overflow-hidden">
          <div
            className="h-full bg-gradient-to-r from-violet-500 to-violet-400 rounded-full transition-all duration-500"
            style={{ width: `${progress}%` }}
          />
        </div>
      </div>

      {/* Messages */}
      <div className="flex-1 overflow-y-auto space-y-4 pr-2">
        {messages.map((msg, i) => (
          <div key={i} className={`flex ${msg.role === 'user' ? 'justify-end' : 'justify-start'}`}>
            {msg.role === 'assistant' && (
              <div className="w-7 h-7 rounded-lg bg-violet-600 flex items-center justify-center shrink-0 mr-2 mt-0.5">
                <Mic size={13} className="text-white" />
              </div>
            )}
            <div className={`max-w-[85%] rounded-2xl px-4 py-3 text-sm leading-relaxed
              ${msg.role === 'user'
                ? 'bg-violet-600 text-white rounded-tr-sm'
                : 'bg-quest-card border border-white/10 text-gray-200 rounded-tl-sm'}`}
            >
              {msg.content}
            </div>
          </div>
        ))}

        {/* Evaluation of previous answer */}
        {lastEvaluation && (
          <div className="mx-auto max-w-[85%] bg-emerald-500/10 border border-emerald-500/20 rounded-xl px-4 py-3">
            <div className="text-xs font-semibold text-emerald-400 mb-1">{t('iv.feedback')}</div>
            <p className="text-sm text-gray-300">{lastEvaluation}</p>
          </div>
        )}

        {loading && (
          <div className="flex justify-start">
            <div className="w-7 h-7 rounded-lg bg-violet-600 flex items-center justify-center shrink-0 mr-2 mt-0.5">
              <Mic size={13} className="text-white" />
            </div>
            <div className="bg-quest-card border border-white/10 rounded-2xl rounded-tl-sm px-4 py-3">
              <div className="flex gap-1">
                {[0, 1, 2].map((i) => (
                  <div key={i} className="w-1.5 h-1.5 bg-gray-500 rounded-full animate-bounce" style={{ animationDelay: `${i * 0.15}s` }} />
                ))}
              </div>
            </div>
          </div>
        )}

        {finishing && (
          <div className="text-center py-4 text-gray-400 text-sm">
            {t('iv.analyzing')}
          </div>
        )}

        <div ref={bottomRef} />
      </div>

      {/* Input */}
      {!finishing && (
        <div className="mt-4 flex gap-3 items-end">
          <textarea
            value={answer}
            onChange={(e) => setAnswer(e.target.value)}
            onKeyDown={(e) => { if (e.key === 'Enter' && (e.metaKey || e.ctrlKey)) handleSubmit() }}
            placeholder={t('iv.answerPlaceholder')}
            rows={3}
            className="flex-1 bg-quest-card border border-white/10 rounded-xl px-4 py-3 text-white text-sm
                       placeholder-gray-500 resize-none focus:outline-none focus:border-violet-500/50"
            disabled={loading || finishing}
          />
          <button
            onClick={handleSubmit}
            disabled={!answer.trim() || loading || finishing}
            className="p-3 bg-violet-600 hover:bg-violet-500 disabled:opacity-40 text-white
                       rounded-xl transition-colors shrink-0"
          >
            <Send size={18} />
          </button>
        </div>
      )}

      {qNumber === TOTAL_QUESTIONS && !loading && !finishing && (
        <p className="text-center text-xs text-amber-400 mt-2">
          {t('iv.finalQuestion')}
        </p>
      )}
    </div>
  )
}

// ── Summary screen ────────────────────────────────────────────────────────────

function Summary({ summary, company, focus, onRestart }: {
  summary: InterviewSummary
  company: string
  focus: string
  onRestart: () => void
}) {
  const t = useT()
  const scoreColor = summary.score >= 8 ? 'text-emerald-400' : summary.score >= 6 ? 'text-amber-400' : 'text-red-400'

  return (
    <div className="max-w-2xl mx-auto px-4 py-10">
      <div className="text-center mb-8">
        <Trophy size={48} className={`mx-auto mb-4 ${scoreColor}`} />
        <h1 className="text-3xl font-bold text-white mb-1">{t('iv.complete')}</h1>
        <p className="text-gray-400">{company} · {focus}</p>
      </div>

      {/* Score */}
      <div className="bg-quest-card border border-white/10 rounded-2xl p-6 text-center mb-6">
        <div className={`text-7xl font-bold mb-1 ${scoreColor}`}>{summary.score}</div>
        <div className="text-gray-400 text-lg">/10</div>
        <p className="text-gray-300 mt-4 text-sm leading-relaxed">{summary.overall_feedback}</p>
      </div>

      <div className="grid grid-cols-1 sm:grid-cols-2 gap-4 mb-6">
        {/* Strongest */}
        <div className="bg-emerald-500/10 border border-emerald-500/20 rounded-xl p-4">
          <div className="text-xs font-semibold text-emerald-400 uppercase tracking-wide mb-3">{t('iv.strongest')}</div>
          <ul className="space-y-1.5">
            {summary.strongest_areas.map((a, i) => (
              <li key={i} className="text-sm text-gray-300 flex items-start gap-2">
                <span className="text-emerald-400 shrink-0 mt-0.5">•</span>
                {a}
              </li>
            ))}
          </ul>
        </div>

        {/* Weakest */}
        <div className="bg-red-500/10 border border-red-500/20 rounded-xl p-4">
          <div className="text-xs font-semibold text-red-400 uppercase tracking-wide mb-3">{t('iv.needsWork')}</div>
          <ul className="space-y-1.5">
            {summary.weakest_areas.map((a, i) => (
              <li key={i} className="text-sm text-gray-300 flex items-start gap-2">
                <span className="text-red-400 shrink-0 mt-0.5">•</span>
                {a}
              </li>
            ))}
          </ul>
        </div>
      </div>

      {/* Study topics */}
      <div className="bg-violet-500/10 border border-violet-500/20 rounded-xl p-4 mb-6">
        <div className="text-xs font-semibold text-violet-400 uppercase tracking-wide mb-3">
          {t('iv.study')}
        </div>
        <ul className="space-y-1.5">
          {summary.study_topics.map((topic, i) => (
            <li key={i} className="text-sm text-gray-300 flex items-start gap-2">
              <span className="text-violet-400 shrink-0 mt-0.5">→</span>
              {topic}
            </li>
          ))}
        </ul>
      </div>

      <div className="flex gap-3">
        <button
          onClick={onRestart}
          className="flex-1 flex items-center justify-center gap-2 py-3 bg-violet-600 hover:bg-violet-500
                     text-white font-semibold rounded-xl transition-colors"
        >
          <RotateCcw size={16} />
          {t('iv.newInterview')}
        </button>
        <a
          href="/my-path"
          className="flex-1 flex items-center justify-center py-3 border border-white/10
                     text-gray-300 hover:text-white hover:border-white/30 rounded-xl transition-colors text-sm font-medium"
        >
          {t('iv.goToPath')}
        </a>
      </div>
    </div>
  )
}

// ── History screen ────────────────────────────────────────────────────────────

function HistoryList({ onBack }: { onBack: () => void }) {
  const t = useT()
  const [detailSessionId, setDetailSessionId] = useState<number | null>(null)

  const { data, isLoading } = useQuery({
    queryKey: ['interview-history'],
    queryFn: fetchInterviewHistory,
  })

  const { data: sessionDetail, isLoading: loadingDetail } = useQuery({
    queryKey: ['interview-session', detailSessionId],
    queryFn: () => fetchInterviewSession(detailSessionId!),
    enabled: detailSessionId !== null,
  })

  if (isLoading) return <div className="text-center py-20 text-gray-400">{t('iv.loadingHistory')}</div>

  return (
    <div className="max-w-2xl mx-auto px-4 py-8">
      <div className="flex items-center gap-3 mb-6">
        <button onClick={onBack} className="text-gray-400 hover:text-white transition-colors text-sm">
          {t('iv.back')}
        </button>
        <h1 className="text-xl font-bold text-white">{t('iv.historyTitle')}</h1>
      </div>

      {!data?.sessions.length ? (
        <div className="text-center py-16 text-gray-500">{t('iv.noHistory')}</div>
      ) : (
        <div className="space-y-3">
          {data.sessions.map((s: InterviewSession) => (
            <div key={s.id} className="bg-quest-card border border-white/10 rounded-xl p-4">
              <div className="flex items-center justify-between mb-2">
                <div>
                  <div className="font-medium text-white text-sm">{s.company_size} · {s.focus}</div>
                  <div className="text-xs text-gray-500 mt-0.5">
                    {s.completed_at ? new Date(s.completed_at).toLocaleDateString() : t('iv.inProgress')}
                  </div>
                </div>
                <div className="flex items-center gap-3">
                  {s.score !== null && (
                    <div className={`text-2xl font-bold ${s.score >= 8 ? 'text-emerald-400' : s.score >= 6 ? 'text-amber-400' : 'text-red-400'}`}>
                      {s.score}/10
                    </div>
                  )}
                  {s.completed_at && (
                    <button
                      onClick={() => setDetailSessionId(s.id)}
                      className="text-xs text-violet-400 hover:text-violet-300 border border-violet-500/30 hover:border-violet-400/50 rounded-lg px-2.5 py-1 transition-colors"
                    >
                      View Q&A
                    </button>
                  )}
                  {s.score === null && !s.completed_at && (
                    <div className="text-gray-500 text-sm">—</div>
                  )}
                </div>
              </div>
              {s.feedback?.overall_feedback && (
                <p className="text-xs text-gray-400 line-clamp-2">{s.feedback.overall_feedback}</p>
              )}
            </div>
          ))}
        </div>
      )}

      {/* Q&A Detail Modal */}
      {detailSessionId !== null && (
        <div
          className="fixed inset-0 bg-black/60 flex items-center justify-center z-50 p-4"
          onClick={() => setDetailSessionId(null)}
        >
          <motion.div
            initial={{ opacity: 0, scale: 0.95 }}
            animate={{ opacity: 1, scale: 1 }}
            className="bg-quest-card border border-white/10 rounded-2xl max-w-2xl w-full max-h-[80vh] overflow-y-auto p-6"
            onClick={e => e.stopPropagation()}
          >
            <div className="flex items-center justify-between mb-4">
              <h3 className="font-bold text-white text-lg">{t('iv.reviewTitle')}</h3>
              <button
                onClick={() => setDetailSessionId(null)}
                className="text-gray-400 hover:text-white transition-colors"
              >
                ✕
              </button>
            </div>

            {loadingDetail ? (
              <div className="text-center py-8 text-gray-400">{t('iv.loadingQA')}</div>
            ) : sessionDetail ? (
              <div className="space-y-3">
                {sessionDetail.qa_pairs.map((msg, i) =>
                  msg.role !== 'system' ? (
                    <div
                      key={i}
                      className={`p-3 rounded-xl text-sm ${
                        msg.role === 'user'
                          ? 'bg-violet-500/10 border border-violet-500/20 text-white'
                          : 'bg-white/5 border border-white/10 text-gray-300'
                      }`}
                    >
                      <p className="text-xs text-gray-500 font-semibold mb-1 uppercase">
                        {msg.role === 'user' ? t('iv.you') : t('iv.interviewer')}
                      </p>
                      <p className="whitespace-pre-wrap leading-relaxed">{msg.content}</p>
                    </div>
                  ) : null
                )}
              </div>
            ) : null}
          </motion.div>
        </div>
      )}
    </div>
  )
}

// ── Root component ────────────────────────────────────────────────────────────

export default function InterviewSimulator() {
  const t = useT()
  const [stage, setStage] = useState<Stage>('setup')
  const [sessionId, setSessionId] = useState<number | null>(null)
  const [company, setCompany] = useState('')
  const [focus, setFocus] = useState('')
  const [firstQuestion, setFirstQuestion] = useState('')
  const [summary, setSummary] = useState<InterviewSummary | null>(null)
  const [error, setError] = useState('')
  const [starting, setStarting] = useState(false)

  const handleStart = async (c: string, f: string) => {
    setError('')
    setStarting(true)
    try {
      const result = await startInterview(c, f)
      setSessionId(result.session_id)
      setCompany(c)
      setFocus(f)
      setFirstQuestion(result.question)
      setStage('active')
    } catch {
      setError(t('iv.startError'))
    } finally {
      setStarting(false)
    }
  }

  const handleComplete = (s: InterviewSummary) => {
    setSummary(s)
    setStage('complete')
  }

  const handleRestart = () => {
    setStage('setup')
    setSessionId(null)
    setSummary(null)
    setError('')
  }

  if (stage === 'history') return <HistoryList onBack={() => setStage('setup')} />

  if (stage === 'complete' && summary) {
    return <Summary summary={summary} company={company} focus={focus} onRestart={handleRestart} />
  }

  if (stage === 'active' && sessionId && firstQuestion) {
    return (
      <InterviewChat
        sessionId={sessionId}
        company={company}
        focus={focus}
        firstQuestion={firstQuestion}
        onComplete={handleComplete}
      />
    )
  }

  return (
    <div>
      {error && (
        <div className="max-w-2xl mx-auto px-4 pt-6">
          <div className="flex items-center gap-2 p-4 bg-red-500/10 border border-red-500/20 rounded-xl text-red-400 text-sm mb-4">
            <AlertCircle size={16} />
            {error}
          </div>
        </div>
      )}
      <div className="flex justify-end max-w-2xl mx-auto px-4 pt-4">
        <button
          onClick={() => setStage('history')}
          className="flex items-center gap-1.5 text-sm text-gray-400 hover:text-white transition-colors"
        >
          <History size={14} />
          {t('iv.history')}
        </button>
      </div>
      <Setup onStart={handleStart} loading={starting} />
    </div>
  )
}

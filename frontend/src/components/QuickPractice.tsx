import { useState } from 'react'
import { motion, AnimatePresence } from 'framer-motion'
import { X, CheckCircle, XCircle, Zap, ChevronRight, Trophy } from 'lucide-react'
import api from '../lib/api'
import { useT } from '../i18n/useT'

interface QuizLesson {
  id: number
  title: string
  topic_title: string
  content_json: {
    question: string
    options: string[]
    correct_index: number
    explanation: string
  }
}

interface Props {
  onClose: () => void
}

export default function QuickPractice({ onClose }: Props) {
  const t = useT()
  const [questions, setQuestions] = useState<QuizLesson[]>([])
  const [loading, setLoading] = useState(false)
  const [started, setStarted] = useState(false)
  const [current, setCurrent] = useState(0)
  const [selected, setSelected] = useState<number | null>(null)
  const [answered, setAnswered] = useState(false)
  const [score, setScore] = useState(0)
  const [finished, setFinished] = useState(false)

  async function startPractice() {
    setLoading(true)
    try {
      const { data } = await api.get<QuizLesson[]>('/lessons/quick-practice?count=5')
      if (data.length === 0) {
        alert(t('quick.noLessons'))
        onClose()
        return
      }
      setQuestions(data)
      setStarted(true)
    } catch {
      alert(t('quick.loadError'))
      onClose()
    } finally {
      setLoading(false)
    }
  }

  function handleAnswer(idx: number) {
    if (answered) return
    setSelected(idx)
    setAnswered(true)
    if (idx === questions[current].content_json.correct_index) {
      setScore(s => s + 1)
    }
  }

  function next() {
    if (current + 1 >= questions.length) {
      setFinished(true)
    } else {
      setCurrent(c => c + 1)
      setSelected(null)
      setAnswered(false)
    }
  }

  const q = questions[current]
  const pct = Math.round((score / questions.length) * 100)

  return (
    <motion.div
      initial={{ opacity: 0 }}
      animate={{ opacity: 1 }}
      exit={{ opacity: 0 }}
      className="fixed inset-0 z-50 flex items-center justify-center bg-black/70 backdrop-blur-sm p-4"
      onClick={onClose}
    >
      <motion.div
        initial={{ scale: 0.92, opacity: 0 }}
        animate={{ scale: 1, opacity: 1 }}
        exit={{ scale: 0.92, opacity: 0 }}
        onClick={e => e.stopPropagation()}
        className="w-full max-w-lg bg-quest-card border border-quest-border rounded-2xl shadow-2xl overflow-hidden"
      >
        {/* Header */}
        <div className="flex items-center justify-between px-5 py-4 border-b border-quest-border"
          style={{ background: 'linear-gradient(135deg, rgba(124,58,237,0.15) 0%, rgba(99,102,241,0.08) 100%)' }}>
          <div className="flex items-center gap-2">
            <Zap className="w-5 h-5 text-quest-purple" />
            <span className="font-bold text-white">Quick Practice</span>
          </div>
          <button onClick={onClose} className="text-quest-muted hover:text-quest-text transition-colors">
            <X className="w-5 h-5" />
          </button>
        </div>

        <div className="p-6">
          {/* Start screen */}
          {!started && !loading && (
            <div className="text-center space-y-4">
              <div className="text-6xl">🧠</div>
              <h2 className="text-xl font-bold text-white">{t('quick.testKnowledge')}</h2>
              <p className="text-quest-muted text-sm">
                {t('quick.description')}
              </p>
              <button onClick={startPractice} className="btn-primary w-full mt-2">
                {t('quick.start')}
              </button>
            </div>
          )}

          {loading && (
            <div className="text-center py-8 text-quest-muted">{t('quick.loading')}</div>
          )}

          {/* Quiz */}
          {started && !finished && q && (
            <div className="space-y-4">
              {/* Progress */}
              <div>
                <div className="flex justify-between text-xs text-quest-muted mb-1">
                  <span>{t('quick.question')} {current + 1} {t('quick.of')} {questions.length}</span>
                  <span>{score} {t('quick.correct')}</span>
                </div>
                <div className="w-full bg-quest-border rounded-full h-1.5">
                  <div className="bg-quest-purple h-1.5 rounded-full transition-all duration-300"
                    style={{ width: `${((current) / questions.length) * 100}%` }} />
                </div>
              </div>

              {/* Topic label */}
              <p className="text-xs text-quest-muted">{q.topic_title}</p>

              {/* Question */}
              <p className="font-semibold text-white text-base leading-snug">{q.content_json.question}</p>

              {/* Options */}
              <div className="space-y-2">
                {q.content_json.options.map((opt, i) => {
                  const isCorrect = i === q.content_json.correct_index
                  const isSelected = i === selected
                  let cls = 'border border-quest-border bg-quest-bg text-quest-text hover:border-quest-purple/50 cursor-pointer'
                  if (answered) {
                    if (isCorrect) cls = 'border border-quest-green bg-quest-green/10 text-quest-green'
                    else if (isSelected) cls = 'border border-red-400 bg-red-400/10 text-red-400'
                    else cls = 'border border-quest-border/50 bg-quest-bg/50 text-quest-muted opacity-60'
                  }
                  return (
                    <button
                      key={i}
                      onClick={() => handleAnswer(i)}
                      className={`w-full text-left text-sm px-4 py-3 rounded-xl transition-all flex items-center gap-3 ${cls}`}
                    >
                      <span className="font-mono text-xs opacity-60">{String.fromCharCode(65 + i)}.</span>
                      <span>{opt}</span>
                      {answered && isCorrect && <CheckCircle className="w-4 h-4 ml-auto flex-shrink-0" />}
                      {answered && isSelected && !isCorrect && <XCircle className="w-4 h-4 ml-auto flex-shrink-0" />}
                    </button>
                  )
                })}
              </div>

              {/* Explanation + next */}
              <AnimatePresence>
                {answered && (
                  <motion.div initial={{ opacity: 0, y: 6 }} animate={{ opacity: 1, y: 0 }}>
                    <p className="text-xs text-quest-muted bg-quest-surface border border-quest-border rounded-xl px-4 py-3">
                      {q.content_json.explanation}
                    </p>
                    <button onClick={next} className="btn-primary w-full mt-3 flex items-center justify-center gap-2">
                      {current + 1 >= questions.length ? t('quick.viewResult') : t('quick.next')}
                      <ChevronRight className="w-4 h-4" />
                    </button>
                  </motion.div>
                )}
              </AnimatePresence>
            </div>
          )}

          {/* Results */}
          {finished && (
            <div className="text-center space-y-4">
              <Trophy className={`w-16 h-16 mx-auto ${pct >= 80 ? 'text-quest-yellow' : pct >= 60 ? 'text-quest-purple' : 'text-quest-muted'}`} />
              <div>
                <p className="text-4xl font-extrabold text-white">{score}/{questions.length}</p>
                <p className={`text-lg font-semibold mt-1 ${pct >= 80 ? 'text-quest-yellow' : pct >= 60 ? 'text-quest-green' : 'text-red-400'}`}>
                  {pct >= 80 ? t('quick.excellent') : pct >= 60 ? t('quick.goodJob') : t('quick.keepPracticing')}
                </p>
              </div>
              <div className="w-full bg-quest-border rounded-full h-3">
                <div className={`h-3 rounded-full transition-all duration-700 ${pct >= 80 ? 'bg-quest-yellow' : pct >= 60 ? 'bg-quest-green' : 'bg-red-400'}`}
                  style={{ width: `${pct}%` }} />
              </div>
              <div className="flex gap-3 pt-2">
                <button onClick={onClose} className="btn-secondary flex-1">{t('quick.close')}</button>
                <button onClick={() => {
                  setStarted(false); setFinished(false); setCurrent(0);
                  setScore(0); setSelected(null); setAnswered(false); setQuestions([])
                }} className="btn-primary flex-1">{t('quick.tryAgain')}</button>
              </div>
            </div>
          )}
        </div>
      </motion.div>
    </motion.div>
  )
}

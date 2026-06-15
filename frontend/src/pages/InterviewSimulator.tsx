import { useState, useRef, useEffect } from 'react'
import { useQuery } from '@tanstack/react-query'
import { Mic, Send, Trophy, AlertCircle, ChevronRight, RotateCcw, History } from 'lucide-react'
import { startInterview, sendInterviewMessage, completeInterview, fetchInterviewHistory } from '../lib/api'
import type { QAPair, InterviewSummary, InterviewSession } from '../types'

const TOTAL_QUESTIONS = 10

const COMPANY_OPTIONS = [
  { value: 'Startup / Small Company',    label: 'Startup / Small', icon: '🚀', desc: 'Portfolio, side projects, can-do attitude' },
  { value: 'Medium Company',             label: 'Medium Company',  icon: '🏢', desc: 'Code quality, process, teamwork' },
  { value: 'Large Corporation',          label: 'Large Corp',      icon: '🏦', desc: 'DS&A, system design, behavioral' },
]

const FOCUS_OPTIONS = [
  { value: 'Frontend', label: 'Frontend', icon: '🎨', desc: 'React, TypeScript, CSS, performance' },
  { value: 'Backend',  label: 'Backend',  icon: '⚙️', desc: 'APIs, databases, auth, SQL' },
  { value: 'Fullstack',label: 'Fullstack',icon: '🔄', desc: 'Everything — end-to-end feature development' },
]

type Stage = 'setup' | 'active' | 'complete' | 'history'

interface Message { role: 'user' | 'assistant'; content: string }

// ── Setup screen ──────────────────────────────────────────────────────────────

function Setup({ onStart, loading }: { onStart: (company: string, focus: string) => void; loading: boolean }) {
  const [company, setCompany] = useState('')
  const [focus, setFocus] = useState('')

  return (
    <div className="max-w-2xl mx-auto px-4 py-12">
      <div className="text-center mb-10">
        <div className="inline-flex items-center justify-center w-16 h-16 bg-violet-500/20 rounded-2xl mb-4">
          <Mic size={28} className="text-violet-400" />
        </div>
        <h1 className="text-3xl font-bold text-white mb-2">Interview Simulator</h1>
        <p className="text-gray-400">
          A senior dev will interview you. 10 questions, real feedback after each answer.
          No AI help allowed — this is to practice.
        </p>
      </div>

      <div className="space-y-6">
        <div>
          <label className="text-sm font-semibold text-gray-400 uppercase tracking-wide block mb-3">
            Target Company Type
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
            Focus Area
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
          {loading ? 'Starting interview...' : 'Start Interview →'}
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
      setMessages((prev) => [...prev, { role: 'assistant', content: 'Sorry, connection error. Please try again.' }])
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
            Question {Math.min(qNumber, TOTAL_QUESTIONS)}/{TOTAL_QUESTIONS}
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
            <div className="text-xs font-semibold text-emerald-400 mb-1">Interviewer Feedback</div>
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
            Analyzing your interview... generating feedback...
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
            placeholder="Type your answer... (Cmd+Enter to submit)"
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
          This is your final question. After submitting, you'll get your full assessment.
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
  const scoreColor = summary.score >= 8 ? 'text-emerald-400' : summary.score >= 6 ? 'text-amber-400' : 'text-red-400'

  return (
    <div className="max-w-2xl mx-auto px-4 py-10">
      <div className="text-center mb-8">
        <Trophy size={48} className={`mx-auto mb-4 ${scoreColor}`} />
        <h1 className="text-3xl font-bold text-white mb-1">Interview Complete</h1>
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
          <div className="text-xs font-semibold text-emerald-400 uppercase tracking-wide mb-3">✅ Strongest Areas</div>
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
          <div className="text-xs font-semibold text-red-400 uppercase tracking-wide mb-3">⚠️ Needs Work</div>
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
          📚 Study Before Your Next Interview
        </div>
        <ul className="space-y-1.5">
          {summary.study_topics.map((t, i) => (
            <li key={i} className="text-sm text-gray-300 flex items-start gap-2">
              <span className="text-violet-400 shrink-0 mt-0.5">→</span>
              {t}
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
          New Interview
        </button>
        <a
          href="/my-path"
          className="flex-1 flex items-center justify-center py-3 border border-white/10
                     text-gray-300 hover:text-white hover:border-white/30 rounded-xl transition-colors text-sm font-medium"
        >
          Go to My Path
        </a>
      </div>
    </div>
  )
}

// ── History screen ────────────────────────────────────────────────────────────

function HistoryList({ onBack }: { onBack: () => void }) {
  const { data, isLoading } = useQuery({
    queryKey: ['interview-history'],
    queryFn: fetchInterviewHistory,
  })

  if (isLoading) return <div className="text-center py-20 text-gray-400">Loading history...</div>

  return (
    <div className="max-w-2xl mx-auto px-4 py-8">
      <div className="flex items-center gap-3 mb-6">
        <button onClick={onBack} className="text-gray-400 hover:text-white transition-colors text-sm">
          ← Back
        </button>
        <h1 className="text-xl font-bold text-white">Interview History</h1>
      </div>

      {!data?.sessions.length ? (
        <div className="text-center py-16 text-gray-500">No completed interviews yet.</div>
      ) : (
        <div className="space-y-3">
          {data.sessions.map((s: InterviewSession) => (
            <div key={s.id} className="bg-quest-card border border-white/10 rounded-xl p-4">
              <div className="flex items-center justify-between mb-2">
                <div>
                  <div className="font-medium text-white text-sm">{s.company_size} · {s.focus}</div>
                  <div className="text-xs text-gray-500 mt-0.5">
                    {s.completed_at ? new Date(s.completed_at).toLocaleDateString() : 'In progress'}
                  </div>
                </div>
                {s.score !== null ? (
                  <div className={`text-2xl font-bold ${s.score >= 8 ? 'text-emerald-400' : s.score >= 6 ? 'text-amber-400' : 'text-red-400'}`}>
                    {s.score}/10
                  </div>
                ) : (
                  <div className="text-gray-500 text-sm">—</div>
                )}
              </div>
              {s.feedback?.overall_feedback && (
                <p className="text-xs text-gray-400 line-clamp-2">{s.feedback.overall_feedback}</p>
              )}
            </div>
          ))}
        </div>
      )}
    </div>
  )
}

// ── Root component ────────────────────────────────────────────────────────────

export default function InterviewSimulator() {
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
      setError('Failed to start interview. Please try again.')
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
          History
        </button>
      </div>
      <Setup onStart={handleStart} loading={starting} />
    </div>
  )
}

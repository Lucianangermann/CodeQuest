import { useState, useEffect } from 'react'
import { useNavigate } from 'react-router-dom'
import { motion, AnimatePresence } from 'framer-motion'
import { useQuery } from '@tanstack/react-query'
import { ArrowLeft, Lock, Play, Sparkles, HelpCircle, ChevronDown, ChevronUp, Loader2 } from 'lucide-react'
import ReactMarkdown from 'react-markdown'
import remarkGfm from 'remark-gfm'
import { Prism as SyntaxHighlighter } from 'react-syntax-highlighter'
import { vscDarkPlus } from 'react-syntax-highlighter/dist/esm/styles/prism'
import { useUserStore } from '../store/useUserStore'
import { fetchCapstone, askCapstone, evaluateCapstone, fetchTopics, runCode } from '../lib/api'
import Editor from '../components/Editor'
import toast from 'react-hot-toast'

const PROSE =
  'prose prose-invert prose-sm max-w-none ' +
  'prose-headings:text-white prose-headings:font-bold ' +
  'prose-strong:text-white ' +
  'prose-code:text-quest-purple-light prose-code:bg-quest-border prose-code:rounded prose-code:px-1 prose-code:py-0.5 prose-code:text-sm prose-code:before:content-none prose-code:after:content-none ' +
  'prose-ul:text-quest-text prose-li:text-quest-text prose-p:text-quest-text'

export default function Capstone() {
  const navigate = useNavigate()
  const { user } = useUserStore()
  const lang = user?.language_preference || 'javascript'

  const [code, setCode] = useState<string>('')
  const [output, setOutput] = useState<string | null>(null)
  const [running, setRunning] = useState(false)
  const [feedback, setFeedback] = useState<string | null>(null)
  const [evaluating, setEvaluating] = useState(false)
  const [showHelp, setShowHelp] = useState(false)
  const [selectedTopic, setSelectedTopic] = useState<string>('')
  const [question, setQuestion] = useState<string>('')
  const [answer, setAnswer] = useState<string | null>(null)
  const [asking, setAsking] = useState(false)

  const { data: project, isLoading } = useQuery({
    queryKey: ['capstone', lang],
    queryFn: () => fetchCapstone(lang),
    staleTime: 5 * 60 * 1000,
  })

  useEffect(() => {
    if (project?.starter_code && !code) {
      setCode(project.starter_code)
    }
  }, [project?.starter_code])

  const { data: topics = [] } = useQuery({
    queryKey: ['topics', lang],
    queryFn: () => fetchTopics(lang),
  })

  async function handleRun() {
    if (!code.trim()) return
    setRunning(true)
    setOutput(null)
    try {
      const result = await runCode(code, lang)
      setOutput(result.error ? `Error:\n${result.error}` : result.output || '(no output)')
    } catch {
      setOutput('Failed to run code.')
    } finally {
      setRunning(false)
    }
  }

  async function handleEvaluate() {
    if (!code.trim()) {
      toast.error('Write some code first!')
      return
    }
    setEvaluating(true)
    setFeedback(null)
    try {
      const result = await evaluateCapstone(lang, code)
      setFeedback(result.feedback)
    } catch {
      toast.error('Evaluation failed. Try again.')
    } finally {
      setEvaluating(false)
    }
  }

  async function handleAsk() {
    if (!selectedTopic) {
      toast.error('Pick a topic first')
      return
    }
    if (!question.trim()) {
      toast.error('Type your question')
      return
    }
    setAsking(true)
    setAnswer(null)
    try {
      const result = await askCapstone(lang, selectedTopic, question)
      setAnswer(result.answer)
    } catch {
      toast.error('Failed to get answer.')
    } finally {
      setAsking(false)
    }
  }

  if (isLoading) {
    return (
      <div className="flex items-center justify-center min-h-[60vh]">
        <Loader2 className="w-8 h-8 animate-spin text-quest-purple" />
      </div>
    )
  }

  if (!project) {
    return (
      <div className="max-w-2xl mx-auto px-4 py-16 text-center text-quest-muted">
        Kein Projekt für diese Sprache gefunden.
      </div>
    )
  }

  if (!project.is_unlocked) {
    return (
      <div className="max-w-2xl mx-auto px-4 py-24 text-center">
        <div className="w-20 h-20 mx-auto mb-6 rounded-full bg-quest-border flex items-center justify-center">
          <Lock className="w-10 h-10 text-quest-muted" />
        </div>
        <h1 className="text-3xl font-bold text-white mb-3">🏆 Capstone Projekt</h1>
        <p className="text-quest-muted text-lg mb-6">
          Schließe alle Lektionen deines Lernpfads ab, um das Abschlussprojekt freizuschalten.
        </p>
        <button
          onClick={() => navigate('/roadmap')}
          className="btn-primary"
        >
          Zum Lernpfad →
        </button>
      </div>
    )
  }

  return (
    <motion.div
      initial={{ opacity: 0, y: 12 }}
      animate={{ opacity: 1, y: 0 }}
      transition={{ duration: 0.3 }}
      className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-8"
    >
      {/* Header */}
      <div className="flex items-center gap-3 mb-6">
        <button
          onClick={() => navigate('/roadmap')}
          className="p-2 rounded-xl text-quest-muted hover:text-quest-text hover:bg-quest-border transition-all"
        >
          <ArrowLeft className="w-5 h-5" />
        </button>
        <div>
          <div className="flex items-center gap-2">
            <span className="text-2xl">🏆</span>
            <h1 className="text-2xl font-bold text-white">{project.title}</h1>
          </div>
          <p className="text-quest-muted text-sm mt-0.5">Abschlussprojekt — setze alles Gelernte ein</p>
        </div>
      </div>

      <div className="grid grid-cols-1 xl:grid-cols-2 gap-6">
        {/* Left: Task description */}
        <div className="space-y-4">
          {/* Description card */}
          <div className="card">
            <div className={PROSE}>
              <ReactMarkdown remarkPlugins={[remarkGfm]}>{project.description}</ReactMarkdown>
            </div>
          </div>

          {/* Help section */}
          <div className="card">
            <button
              onClick={() => setShowHelp(!showHelp)}
              className="w-full flex items-center justify-between text-left"
            >
              <div className="flex items-center gap-2 text-quest-purple-light font-semibold">
                <HelpCircle className="w-5 h-5" />
                Ich komme nicht weiter — Lernhilfe
              </div>
              {showHelp ? <ChevronUp className="w-4 h-4 text-quest-muted" /> : <ChevronDown className="w-4 h-4 text-quest-muted" />}
            </button>

            <AnimatePresence>
              {showHelp && (
                <motion.div
                  initial={{ opacity: 0, height: 0 }}
                  animate={{ opacity: 1, height: 'auto' }}
                  exit={{ opacity: 0, height: 0 }}
                  transition={{ duration: 0.2 }}
                  className="mt-4 space-y-3 overflow-hidden"
                >
                  <p className="text-sm text-quest-muted">
                    Wähle ein Thema, über das du eine Frage stellen möchtest. Die KI erklärt das Konzept — ohne die Lösung zu verraten.
                  </p>
                  <select
                    value={selectedTopic}
                    onChange={(e) => setSelectedTopic(e.target.value)}
                    className="input text-sm"
                  >
                    <option value="">— Thema auswählen —</option>
                    {topics.map((t) => (
                      <option key={t.id} value={t.title}>{t.title}</option>
                    ))}
                  </select>
                  <textarea
                    value={question}
                    onChange={(e) => setQuestion(e.target.value)}
                    placeholder="Was möchtest du über dieses Thema wissen?"
                    rows={2}
                    className="input text-sm resize-none"
                  />
                  <button
                    onClick={handleAsk}
                    disabled={asking || !selectedTopic || !question.trim()}
                    className="btn-primary w-full flex items-center justify-center gap-2 disabled:opacity-50"
                  >
                    {asking ? <Loader2 className="w-4 h-4 animate-spin" /> : <Sparkles className="w-4 h-4" />}
                    {asking ? 'Wird erklärt...' : 'Konzept erklären'}
                  </button>

                  {answer && (
                    <motion.div
                      initial={{ opacity: 0, y: 8 }}
                      animate={{ opacity: 1, y: 0 }}
                      className="p-4 rounded-xl bg-quest-purple/10 border border-quest-purple/20"
                    >
                      <div className={PROSE}>
                        <ReactMarkdown
                          remarkPlugins={[remarkGfm]}
                          components={{
                            code({ className, children }) {
                              const language = /language-(\w+)/.exec(className || '')?.[1] || 'text'
                              return (
                                <SyntaxHighlighter language={language} style={vscDarkPlus} customStyle={{ margin: 0, borderRadius: 8 }}>
                                  {String(children).replace(/\n$/, '')}
                                </SyntaxHighlighter>
                              )
                            },
                          }}
                        >
                          {answer}
                        </ReactMarkdown>
                      </div>
                    </motion.div>
                  )}
                </motion.div>
              )}
            </AnimatePresence>
          </div>

          {/* AI Feedback */}
          {feedback && (
            <motion.div
              initial={{ opacity: 0, y: 8 }}
              animate={{ opacity: 1, y: 0 }}
              className="card"
            >
              <h3 className="font-semibold text-white mb-3 flex items-center gap-2">
                <Sparkles className="w-4 h-4 text-quest-purple" />
                KI-Bewertung
              </h3>
              <div className={PROSE}>
                <ReactMarkdown
                  remarkPlugins={[remarkGfm]}
                  components={{
                    code({ className, children }) {
                      const language = /language-(\w+)/.exec(className || '')?.[1] || 'text'
                      return (
                        <SyntaxHighlighter language={language} style={vscDarkPlus} customStyle={{ margin: 0, borderRadius: 8 }}>
                          {String(children).replace(/\n$/, '')}
                        </SyntaxHighlighter>
                      )
                    },
                  }}
                >
                  {feedback}
                </ReactMarkdown>
              </div>
            </motion.div>
          )}
        </div>

        {/* Right: Code editor */}
        <div className="space-y-4">
          <div className="card">
            <div className="flex items-center justify-between mb-3">
              <span className="text-sm font-semibold text-quest-muted uppercase tracking-wide">Code</span>
              <span className="text-xs text-quest-muted px-2 py-1 rounded bg-quest-border">{lang}</span>
            </div>
            <Editor
              value={code}
              onChange={setCode}
              language={lang}
              height="400px"
            />
          </div>

          {/* Buttons */}
          <div className="flex gap-3">
            <button
              onClick={handleRun}
              disabled={running}
              className="flex-1 flex items-center justify-center gap-2 py-3 px-4 rounded-xl font-semibold text-sm bg-quest-border hover:bg-quest-border/80 text-quest-text transition-all disabled:opacity-50"
            >
              {running ? <Loader2 className="w-4 h-4 animate-spin" /> : <Play className="w-4 h-4" />}
              {running ? 'Läuft...' : 'Code ausführen'}
            </button>
            <button
              onClick={handleEvaluate}
              disabled={evaluating}
              className="flex-1 flex items-center justify-center gap-2 py-3 px-4 rounded-xl font-semibold text-sm btn-primary disabled:opacity-50"
            >
              {evaluating ? <Loader2 className="w-4 h-4 animate-spin" /> : <Sparkles className="w-4 h-4" />}
              {evaluating ? 'Wird bewertet...' : '✨ KI-Bewertung'}
            </button>
          </div>

          {/* Output */}
          {output !== null && (
            <motion.div
              initial={{ opacity: 0, y: 8 }}
              animate={{ opacity: 1, y: 0 }}
              className="card"
            >
              <h3 className="text-sm font-semibold text-quest-muted uppercase tracking-wide mb-3">Ausgabe</h3>
              <pre className="font-mono text-sm text-quest-text bg-[#0d0d1a] rounded-xl p-4 overflow-x-auto whitespace-pre-wrap">
                {output}
              </pre>
            </motion.div>
          )}
        </div>
      </div>
    </motion.div>
  )
}

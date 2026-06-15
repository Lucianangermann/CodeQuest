import { useState } from 'react'
import { motion } from 'framer-motion'
import { useMutation } from '@tanstack/react-query'
import { Play, Loader2, RotateCcw, Terminal } from 'lucide-react'
import Editor from '../components/Editor'
import { useUserStore } from '../store/useUserStore'
import { runCode } from '../lib/api'

const LANGUAGE_STARTERS: Record<string, string> = {
  python: '# Write your Python code here\nprint("Hello, World!")\n',
  javascript: '// Write your JavaScript code here\nconsole.log("Hello, World!");\n',
  typescript: '// Write your TypeScript code here\nconst msg: string = "Hello, World!";\nconsole.log(msg);\n',
}

export default function Playground() {
  const { user } = useUserStore()
  const language = user?.language_preference || 'python'
  const [code, setCode] = useState(LANGUAGE_STARTERS[language] || LANGUAGE_STARTERS.python)
  const [output, setOutput] = useState<string | null>(null)
  const [error, setError] = useState<string | null>(null)

  const { mutate: run, isPending } = useMutation({
    mutationFn: () => runCode(code, language),
    onSuccess: (data) => {
      setOutput(data.output || null)
      setError(data.error || null)
    },
    onError: () => {
      setError('Failed to run code. Make sure the backend is running.')
    },
  })

  function handleReset() {
    setCode(LANGUAGE_STARTERS[language] || LANGUAGE_STARTERS.python)
    setOutput(null)
    setError(null)
  }

  return (
    <motion.div
      initial={{ opacity: 0, y: 12 }}
      animate={{ opacity: 1, y: 0 }}
      transition={{ duration: 0.3 }}
      className="max-w-4xl mx-auto px-4 sm:px-6 py-8"
    >
      <div className="flex items-center justify-between mb-6">
        <div>
          <h1 className="text-2xl font-bold text-white flex items-center gap-2">
            <Terminal className="w-6 h-6 text-quest-purple" />
            Code Playground
          </h1>
          <p className="text-quest-muted text-sm mt-1">
            Write and run {language} code freely — no lesson required
          </p>
        </div>
        <div className="flex gap-2">
          <button
            onClick={handleReset}
            className="btn-secondary flex items-center gap-1.5 text-sm py-2 px-3"
          >
            <RotateCcw className="w-4 h-4" />
            Reset
          </button>
          <button
            onClick={() => run()}
            disabled={isPending}
            className="btn-primary flex items-center gap-2 text-sm"
          >
            {isPending ? <Loader2 className="w-4 h-4 animate-spin" /> : <Play className="w-4 h-4" />}
            Run Code
          </button>
        </div>
      </div>

      <div className="space-y-4">
        <div className="card p-0 overflow-hidden">
          <div className="flex items-center gap-2 px-4 py-2 bg-[#1e1e2e] border-b border-quest-border text-xs text-quest-muted font-mono">
            <span className="w-3 h-3 rounded-full bg-red-500/70" />
            <span className="w-3 h-3 rounded-full bg-yellow-500/70" />
            <span className="w-3 h-3 rounded-full bg-green-500/70" />
            <span className="ml-2">{language}</span>
          </div>
          <Editor value={code} onChange={setCode} language={language} height="400px" />
        </div>

        {(output !== null || error !== null) && (
          <motion.div
            initial={{ opacity: 0, y: 8 }}
            animate={{ opacity: 1, y: 0 }}
            className={`card font-mono text-sm ${
              error ? 'border-red-500/30 bg-red-500/5' : 'border-quest-green/30 bg-quest-green/5'
            }`}
          >
            <p className={`text-xs font-semibold uppercase tracking-wide mb-2 ${
              error ? 'text-red-400' : 'text-quest-green'
            }`}>
              {error ? 'Error' : 'Output'}
            </p>
            <pre className="whitespace-pre-wrap text-quest-text leading-relaxed">
              {error || output || '(no output)'}
            </pre>
          </motion.div>
        )}
      </div>
    </motion.div>
  )
}

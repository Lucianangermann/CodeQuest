import { useState } from 'react'
import { motion, AnimatePresence } from 'framer-motion'
import { useQuery, useMutation, useQueryClient } from '@tanstack/react-query'
import { Brain, Clock, ChevronRight, Loader2 } from 'lucide-react'
import { fetchDueReviews, submitReviewResult } from '../lib/api'
import ReactMarkdown from 'react-markdown'
import remarkGfm from 'remark-gfm'

const QUALITY_BUTTONS = [
  { quality: 1, label: 'Hard', cls: 'bg-red-500/20 text-red-400 hover:bg-red-500/30 border border-red-500/30' },
  { quality: 3, label: 'Good', cls: 'bg-quest-yellow/20 text-quest-yellow hover:bg-quest-yellow/30 border border-quest-yellow/30' },
  { quality: 5, label: 'Easy', cls: 'bg-quest-green/20 text-quest-green hover:bg-quest-green/30 border border-quest-green/30' },
]

export default function Review() {
  const qc = useQueryClient()
  const [currentIndex, setCurrentIndex] = useState(0)
  const [showAnswer, setShowAnswer] = useState(false)
  const [completed, setCompleted] = useState<number[]>([])

  const { data, isLoading } = useQuery({
    queryKey: ['review-due'],
    queryFn: fetchDueReviews,
  })

  const { mutate: submitResult, isPending } = useMutation({
    mutationFn: ({ lesson_id, quality }: { lesson_id: number; quality: number }) =>
      submitReviewResult(lesson_id, quality),
    onSuccess: (_, vars) => {
      setCompleted(prev => [...prev, vars.lesson_id])
      setShowAnswer(false)
      setCurrentIndex(prev => prev + 1)
      qc.invalidateQueries({ queryKey: ['review-due'] })
      qc.invalidateQueries({ queryKey: ['review-count'] })
    },
  })

  if (isLoading) {
    return (
      <div className="flex items-center justify-center min-h-[60vh]">
        <Loader2 className="w-8 h-8 animate-spin text-quest-purple" />
      </div>
    )
  }

  const due = data?.due ?? []
  const totalDue = due.length
  const reviewedThisSession = completed.length
  const remaining = Math.max(0, totalDue - currentIndex)

  if (due.length === 0 || currentIndex >= due.length) {
    return (
      <motion.div
        initial={{ opacity: 0, y: 12 }}
        animate={{ opacity: 1, y: 0 }}
        className="max-w-2xl mx-auto px-4 py-16 text-center"
      >
        <div className="text-6xl mb-4">🎉</div>
        <h1 className="text-2xl font-bold text-white mb-2">All caught up!</h1>
        <p className="text-quest-muted">
          {completed.length > 0
            ? `You reviewed ${completed.length} card${completed.length === 1 ? '' : 's'} today — well done! 🧠`
            : 'No reviews due today. Keep learning and come back tomorrow!'}
        </p>
        {due.length === 0 && (
          <p className="text-quest-muted text-sm mt-2">
            Next review scheduled based on your performance.
          </p>
        )}
        <div className="mt-8 flex items-center justify-center gap-2 text-quest-muted text-sm">
          <Clock className="w-4 h-4" />
          <span>Spaced repetition keeps knowledge fresh with minimal effort.</span>
        </div>
      </motion.div>
    )
  }

  const card = due[currentIndex]
  const content = card.content as Record<string, unknown>

  // Extract reviewable content based on lesson type
  const questionText =
    card.type === 'quiz'
      ? (content.question as string) ?? card.title
      : card.type === 'theory'
      ? card.title
      : card.title

  const answerText =
    card.type === 'quiz'
      ? (() => {
          const opts = (content.options as string[]) ?? []
          const ci = (content.correct_index as number) ?? 0
          return opts[ci] ? `**${opts[ci]}**\n\n${(content.explanation as string) ?? ''}` : ''
        })()
      : card.type === 'code'
      ? `Expected output:\n\`\`\`\n${(content.expected_output as string) ?? ''}\n\`\`\``
      : ((content.sections as Array<{ content: string }>)?.[0]?.content ?? card.title)

  return (
    <motion.div
      initial={{ opacity: 0, y: 12 }}
      animate={{ opacity: 1, y: 0 }}
      className="max-w-2xl mx-auto px-4 py-8"
    >
      {/* Header */}
      <div className="flex items-center gap-3 mb-6">
        <Brain className="w-6 h-6 text-quest-purple" />
        <h1 className="text-2xl font-bold text-white">Daily Review</h1>
        <span className="ml-auto text-sm text-quest-muted">
          {currentIndex + 1} / {due.length}
        </span>
      </div>

      {/* Stats strip */}
      <div className="flex items-center justify-between mb-4 text-sm">
        <div className="flex items-center gap-4">
          <span className="flex items-center gap-1.5 text-quest-muted">
            <Brain className="w-4 h-4 text-quest-purple" />
            <span><strong className="text-white">{totalDue}</strong> due today</span>
          </span>
          {reviewedThisSession > 0 && (
            <span className="flex items-center gap-1.5 text-quest-green text-xs">
              ✓ {reviewedThisSession} done
            </span>
          )}
        </div>
        <span className="text-quest-muted text-xs">{remaining} remaining</span>
      </div>

      {/* Progress bar */}
      <div className="w-full bg-quest-border rounded-full h-1.5 mb-8">
        <div
          className="bg-quest-purple h-1.5 rounded-full transition-all duration-500"
          style={{ width: `${(currentIndex / due.length) * 100}%` }}
        />
      </div>

      <AnimatePresence mode="wait">
        <motion.div
          key={currentIndex}
          initial={{ opacity: 0, x: 20 }}
          animate={{ opacity: 1, x: 0 }}
          exit={{ opacity: 0, x: -20 }}
          className="card-glow space-y-6"
        >
          {/* Topic badge */}
          <div className="flex items-center gap-2">
            <span className="badge-pill bg-quest-purple/20 text-quest-purple-light text-xs">
              {card.topic_title}
            </span>
            <span className="badge-pill bg-quest-border text-quest-muted text-xs capitalize">
              {card.type}
            </span>
          </div>

          {/* Question */}
          <div>
            <p className="text-xs text-quest-muted uppercase tracking-wide font-semibold mb-2">Question</p>
            <p className="text-lg font-medium text-white leading-relaxed">{questionText}</p>
          </div>

          {/* Answer (hidden until shown) */}
          {!showAnswer ? (
            <button
              onClick={() => setShowAnswer(true)}
              className="btn-secondary w-full flex items-center justify-center gap-2"
            >
              <ChevronRight className="w-4 h-4" />
              Show Answer
            </button>
          ) : (
            <motion.div
              initial={{ opacity: 0, y: 8 }}
              animate={{ opacity: 1, y: 0 }}
              className="space-y-4"
            >
              <div className="p-4 bg-quest-purple/10 border border-quest-purple/20 rounded-xl">
                <p className="text-xs text-quest-muted uppercase tracking-wide font-semibold mb-2">Answer</p>
                <div className="prose prose-invert prose-sm max-w-none prose-code:text-quest-purple-light prose-code:bg-quest-border prose-code:rounded prose-code:px-1">
                  <ReactMarkdown remarkPlugins={[remarkGfm]}>{answerText}</ReactMarkdown>
                </div>
              </div>

              <p className="text-sm text-quest-muted text-center">How well did you remember?</p>

              <div className="flex gap-3">
                {QUALITY_BUTTONS.map(({ quality, label, cls }) => (
                  <button
                    key={quality}
                    disabled={isPending}
                    onClick={() => submitResult({ lesson_id: card.lesson_id, quality })}
                    className={`flex-1 py-3 rounded-xl font-bold text-sm transition-all duration-200 hover:-translate-y-0.5 ${cls} ${isPending ? 'opacity-50 cursor-not-allowed' : 'hover:shadow-lg'}`}
                  >
                    {label}
                  </button>
                ))}
              </div>
            </motion.div>
          )}
        </motion.div>
      </AnimatePresence>
    </motion.div>
  )
}

import { useState } from 'react'
import { motion, AnimatePresence } from 'framer-motion'
import { Lightbulb, ChevronRight, Loader2 } from 'lucide-react'
import { getHint } from '../lib/api'
import { useLessonStore } from '../store/useLessonStore'
import toast from 'react-hot-toast'

interface Props {
  lessonId: number
  userCode: string
  maxHints?: number
}

const HINT_LABELS = ['Gentle Nudge', 'Need More Help?', 'Show Me the Way']

export default function HintSystem({ lessonId, userCode, maxHints = 3 }: Props) {
  const { hintsUsed, currentHint, isLoadingHint, incrementHints, setHint, setLoadingHint } =
    useLessonStore()
  const [isExpanded, setIsExpanded] = useState(false)

  async function handleGetHint() {
    if (hintsUsed >= maxHints) return
    const nextLevel = hintsUsed + 1

    setLoadingHint(true)
    setIsExpanded(true)
    try {
      const hint = await getHint(lessonId, nextLevel, userCode)
      setHint(hint)
      incrementHints()
    } catch {
      toast.error('Could not get hint. Try again.')
    } finally {
      setLoadingHint(false)
    }
  }

  const canGetMoreHints = hintsUsed < maxHints

  return (
    <div className="rounded-2xl border border-quest-yellow/20 bg-quest-yellow/5 overflow-hidden">
      <button
        onClick={() => setIsExpanded(!isExpanded)}
        className="w-full flex items-center justify-between px-4 py-3 text-left"
      >
        <div className="flex items-center gap-2 text-quest-yellow">
          <Lightbulb className="w-4 h-4" />
          <span className="font-medium text-sm">
            Hints ({hintsUsed}/{maxHints} used)
          </span>
        </div>
        <ChevronRight
          className={`w-4 h-4 text-quest-yellow transition-transform ${isExpanded ? 'rotate-90' : ''}`}
        />
      </button>

      <AnimatePresence>
        {isExpanded && (
          <motion.div
            initial={{ height: 0, opacity: 0 }}
            animate={{ height: 'auto', opacity: 1 }}
            exit={{ height: 0, opacity: 0 }}
            transition={{ duration: 0.2 }}
            className="overflow-hidden"
          >
            <div className="px-4 pb-4 space-y-3 border-t border-quest-yellow/10">
              {currentHint && (
                <motion.div
                  initial={{ opacity: 0, y: -8 }}
                  animate={{ opacity: 1, y: 0 }}
                  className="mt-3 bg-quest-card rounded-xl p-3 text-sm text-quest-text leading-relaxed"
                >
                  {currentHint}
                </motion.div>
              )}

              {canGetMoreHints && (
                <button
                  onClick={handleGetHint}
                  disabled={isLoadingHint}
                  className="mt-3 w-full flex items-center justify-center gap-2 py-2 px-4 rounded-xl bg-quest-yellow/10 hover:bg-quest-yellow/20 border border-quest-yellow/30 text-quest-yellow text-sm font-medium transition-all disabled:opacity-50"
                >
                  {isLoadingHint ? (
                    <Loader2 className="w-4 h-4 animate-spin" />
                  ) : (
                    <Lightbulb className="w-4 h-4" />
                  )}
                  {hintsUsed === 0
                    ? 'Get a hint'
                    : HINT_LABELS[Math.min(hintsUsed, HINT_LABELS.length - 1)]}
                </button>
              )}

              {!canGetMoreHints && (
                <p className="text-xs text-quest-muted text-center py-1">
                  No more hints available. You can do it! 💪
                </p>
              )}
            </div>
          </motion.div>
        )}
      </AnimatePresence>
    </div>
  )
}

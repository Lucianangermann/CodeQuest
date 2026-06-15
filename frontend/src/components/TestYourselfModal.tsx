import { useState } from 'react'
import { useQuery } from '@tanstack/react-query'
import { X, HelpCircle, ChevronDown } from 'lucide-react'
import { fetchTestQuestion } from '../lib/api'

interface Props {
  itemKey: string
  itemLabel: string
  onClose: () => void
}

export default function TestYourselfModal({ itemKey, itemLabel, onClose }: Props) {
  const [answer, setAnswer] = useState('')
  const [showExpected, setShowExpected] = useState(false)

  const { data, isLoading } = useQuery({
    queryKey: ['test-question', itemKey],
    queryFn: () => fetchTestQuestion(itemKey),
  })

  return (
    <div className="fixed inset-0 bg-black/60 backdrop-blur-sm z-50 flex items-center justify-center p-4">
      <div className="bg-quest-card border border-white/10 rounded-2xl w-full max-w-lg shadow-2xl">
        <div className="flex items-center justify-between p-5 border-b border-white/10">
          <div className="flex items-center gap-2">
            <HelpCircle size={18} className="text-violet-400" />
            <h2 className="font-semibold text-white">Test Yourself</h2>
          </div>
          <button onClick={onClose} className="text-gray-400 hover:text-white transition-colors">
            <X size={20} />
          </button>
        </div>

        <div className="p-5 space-y-4">
          <div className="text-xs text-gray-500 uppercase tracking-wide">{itemLabel}</div>

          {isLoading ? (
            <div className="text-gray-400 text-sm">Loading question...</div>
          ) : data ? (
            <>
              <p className="text-white font-medium">{data.question}</p>

              <textarea
                value={answer}
                onChange={(e) => setAnswer(e.target.value)}
                placeholder="Type your answer here..."
                rows={4}
                className="w-full bg-white/5 border border-white/10 rounded-lg px-3 py-2 text-white text-sm
                           placeholder-gray-500 resize-none focus:outline-none focus:border-violet-500/50"
              />

              <button
                onClick={() => setShowExpected(!showExpected)}
                className="flex items-center gap-1 text-sm text-gray-400 hover:text-white transition-colors"
              >
                <ChevronDown
                  size={14}
                  className={`transition-transform ${showExpected ? 'rotate-180' : ''}`}
                />
                {showExpected ? 'Hide' : 'Show'} expected answer
              </button>

              {showExpected && (
                <div className="p-4 bg-emerald-500/10 border border-emerald-500/20 rounded-lg text-sm text-emerald-300">
                  {data.expected_answer}
                </div>
              )}
            </>
          ) : null}
        </div>

        <div className="p-5 border-t border-white/10">
          <button
            onClick={onClose}
            className="w-full py-2.5 bg-violet-600 hover:bg-violet-500 text-white font-medium rounded-xl transition-colors"
          >
            Done
          </button>
        </div>
      </div>
    </div>
  )
}

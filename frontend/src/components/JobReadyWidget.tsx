import { useState } from 'react'
import { useQuery, useMutation, useQueryClient } from '@tanstack/react-query'
import { CheckSquare, Square, ChevronUp, ChevronDown, FlaskConical, X } from 'lucide-react'
import { fetchChecklist, updateChecklistItem } from '../lib/api'
import { useUserStore } from '../store/useUserStore'
import TestYourselfModal from './TestYourselfModal'
import type { ChecklistItem } from '../types'
import { useT } from '../i18n/useT'

const CATEGORY_LABELS: Record<string, string> = {
  fundamentals: '🧠 Fundamentals',
  git:          '🌿 Git',
  algorithms:   '⚡ Algorithms',
  portfolio:    '🗂 Portfolio',
  career:       '💼 Career',
}

export default function JobReadyWidget() {
  const t = useT()
  const user = useUserStore((s) => s.user)
  const qc = useQueryClient()

  const [open, setOpen] = useState(false)
  const [testItem, setTestItem] = useState<ChecklistItem | null>(null)

  const { data } = useQuery({
    queryKey: ['checklist'],
    queryFn: fetchChecklist,
    enabled: open,
  })

  const toggleMutation = useMutation({
    mutationFn: ({ key, completed }: { key: string; completed: boolean }) =>
      updateChecklistItem(key, completed),
    onMutate: async ({ key, completed }) => {
      await qc.cancelQueries({ queryKey: ['checklist'] })
      const prev = qc.getQueryData<{ items: ChecklistItem[] }>(['checklist'])
      qc.setQueryData<{ items: ChecklistItem[] }>(['checklist'], (old) =>
        old
          ? { items: old.items.map((i) => (i.key === key ? { ...i, completed } : i)) }
          : old,
      )
      return { prev }
    },
    onError: (_err, _vars, ctx) => {
      if (ctx?.prev) qc.setQueryData(['checklist'], ctx.prev)
    },
  })

  // Only show for job-seekers (goal contains "job" — we check onboarding was done + plan has job goal)
  // We show it for all users who completed onboarding, let them decide
  if (!user?.onboarding_completed) return null

  const items = data?.items ?? []
  const completed = items.filter((i) => i.completed).length
  const pct = items.length ? Math.round((completed / items.length) * 100) : 0

  const grouped = items.reduce<Record<string, ChecklistItem[]>>((acc, item) => {
    if (!acc[item.category]) acc[item.category] = []
    acc[item.category].push(item)
    return acc
  }, {})

  return (
    <>
      {testItem && (
        <TestYourselfModal
          itemKey={testItem.key}
          itemLabel={testItem.label}
          onClose={() => setTestItem(null)}
        />
      )}

      <div className="fixed bottom-20 right-4 z-40 flex flex-col items-end gap-2">
        {open && (
          <div className="bg-quest-card border border-white/10 rounded-2xl shadow-2xl w-80 max-h-[70vh] flex flex-col">
            {/* Header */}
            <div className="flex items-center justify-between p-4 border-b border-white/10">
              <div>
                <div className="text-sm font-semibold text-white">{t('job.title')}</div>
                <div className="text-xs text-gray-400 mt-0.5">{completed}/{items.length} {t('job.complete')}</div>
              </div>
              <button onClick={() => setOpen(false)} className="text-gray-400 hover:text-white">
                <X size={16} />
              </button>
            </div>

            {/* Progress bar */}
            <div className="px-4 py-2">
              <div className="h-1.5 bg-white/10 rounded-full overflow-hidden">
                <div
                  className="h-full bg-gradient-to-r from-violet-500 to-emerald-500 rounded-full transition-all"
                  style={{ width: `${pct}%` }}
                />
              </div>
              <div className="text-xs text-gray-500 mt-1">{pct}{t('job.ready')}</div>
            </div>

            {/* Items */}
            <div className="flex-1 overflow-y-auto px-4 pb-4 space-y-4">
              {Object.entries(CATEGORY_LABELS).map(([cat, catLabel]) => {
                const catItems = grouped[cat]
                if (!catItems?.length) return null
                return (
                  <div key={cat}>
                    <div className="text-xs font-semibold text-gray-500 uppercase tracking-wide mb-2">
                      {catLabel}
                    </div>
                    <div className="space-y-1">
                      {catItems.map((item) => (
                        <div
                          key={item.key}
                          className="flex items-center gap-2 group"
                        >
                          <button
                            onClick={() => toggleMutation.mutate({ key: item.key, completed: !item.completed })}
                            className={`shrink-0 transition-colors ${
                              item.completed ? 'text-emerald-400' : 'text-gray-500 hover:text-violet-400'
                            }`}
                          >
                            {item.completed ? <CheckSquare size={16} /> : <Square size={16} />}
                          </button>
                          <span
                            className={`flex-1 text-sm transition-colors ${
                              item.completed ? 'text-gray-500 line-through' : 'text-gray-300'
                            }`}
                          >
                            {item.label}
                          </span>
                          <button
                            onClick={() => setTestItem(item)}
                            className="opacity-0 group-hover:opacity-100 transition-opacity text-gray-500 hover:text-violet-400"
                            title="Test yourself"
                          >
                            <FlaskConical size={12} />
                          </button>
                        </div>
                      ))}
                    </div>
                  </div>
                )
              })}
            </div>
          </div>
        )}

        {/* Toggle button */}
        <button
          onClick={() => setOpen(!open)}
          className="flex items-center gap-2 bg-violet-600 hover:bg-violet-500 text-white
                     px-4 py-2.5 rounded-xl shadow-lg font-medium text-sm transition-colors"
        >
          <CheckSquare size={16} />
          {t('job.btn')}
          {items.length > 0 && (
            <span className="bg-white/20 text-xs px-1.5 py-0.5 rounded-full">{pct}%</span>
          )}
          {open ? <ChevronDown size={14} /> : <ChevronUp size={14} />}
        </button>
      </div>
    </>
  )
}

import { useQuery, useMutation, useQueryClient } from '@tanstack/react-query'
import { CheckSquare, Square, BookOpen } from 'lucide-react'
import { fetchIHKChecklist, updateIHKChecklistItem } from '../lib/api'
import type { IHKChecklistItem } from '../types'

const CATEGORY_LABELS: Record<string, string> = {
  teil1:   'Teil 1 — nach 18 Monaten',
  wiso:    'WiSo — Wirtschafts- und Sozialkunde',
  teil2:   'Teil 2 — Abschlussprüfung',
  projekt: 'Abschlussprojekt',
}

export default function IHKCheckliste() {
  const queryClient = useQueryClient()

  const { data, isLoading } = useQuery({
    queryKey: ['ihk-checklist'],
    queryFn: fetchIHKChecklist,
  })

  const toggle = useMutation({
    mutationFn: ({ key, completed }: { key: string; completed: boolean }) =>
      updateIHKChecklistItem(key, completed),
    onSuccess: () => queryClient.invalidateQueries({ queryKey: ['ihk-checklist'] }),
  })

  if (isLoading) return null

  const items = data?.items ?? []
  const completed = items.filter(i => i.completed).length
  const total = items.length
  const pct = total > 0 ? Math.round((completed / total) * 100) : 0

  const byCategory = items.reduce((acc, item) => {
    if (!acc[item.category]) acc[item.category] = []
    acc[item.category].push(item)
    return acc
  }, {} as Record<string, IHKChecklistItem[]>)

  return (
    <div className="card mt-6">
      <div className="flex items-center justify-between mb-4">
        <div className="flex items-center gap-2">
          <BookOpen className="w-5 h-5 text-quest-purple" />
          <h3 className="font-semibold text-white">IHK-Prüfungs-Checkliste</h3>
        </div>
        <span className="text-sm text-quest-muted">{completed}/{total} — {pct}% bereit</span>
      </div>

      <div className="w-full bg-quest-border rounded-full h-2 mb-6">
        <div
          className="bg-quest-purple h-2 rounded-full transition-all"
          style={{ width: `${pct}%` }}
        />
      </div>

      <div className="space-y-6">
        {Object.entries(CATEGORY_LABELS).map(([cat, catLabel]) => {
          const catItems = byCategory[cat] ?? []
          if (!catItems.length) return null
          return (
            <div key={cat}>
              <p className="text-xs font-bold text-quest-muted uppercase tracking-wide mb-2">{catLabel}</p>
              <div className="space-y-2">
                {catItems.map(item => (
                  <button
                    key={item.key}
                    onClick={() => toggle.mutate({ key: item.key, completed: !item.completed })}
                    className="w-full flex items-center gap-3 p-3 rounded-xl bg-quest-border/30 hover:bg-quest-border/60 transition-colors text-left"
                  >
                    {item.completed
                      ? <CheckSquare className="w-4 h-4 text-quest-green flex-shrink-0" />
                      : <Square className="w-4 h-4 text-quest-muted flex-shrink-0" />
                    }
                    <span className={`text-sm ${item.completed ? 'text-quest-muted line-through' : 'text-quest-text'}`}>
                      {item.label}
                    </span>
                  </button>
                ))}
              </div>
            </div>
          )
        })}
      </div>
    </div>
  )
}

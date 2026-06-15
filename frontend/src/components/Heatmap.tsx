import { useMemo } from 'react'
import type { ActivityEntry } from '../types'

interface Props {
  data: ActivityEntry[]
}

function getLast90Days(): string[] {
  const days: string[] = []
  for (let i = 89; i >= 0; i--) {
    const d = new Date()
    d.setDate(d.getDate() - i)
    days.push(d.toISOString().split('T')[0])
  }
  return days
}

function getIntensity(xp: number): string {
  if (xp === 0) return 'bg-quest-border'
  if (xp < 20) return 'bg-quest-purple/25'
  if (xp < 40) return 'bg-quest-purple/50'
  if (xp < 60) return 'bg-quest-purple/75'
  return 'bg-quest-purple'
}

export default function Heatmap({ data }: Props) {
  const days = useMemo(() => getLast90Days(), [])
  const dataMap = useMemo(
    () => Object.fromEntries(data.map((d) => [d.date, d])),
    [data]
  )

  // Group into weeks (columns)
  const weeks: string[][] = []
  const startOffset = new Date(days[0]).getDay() // 0=Sun
  const paddedDays = [...Array(startOffset).fill(''), ...days]
  for (let i = 0; i < paddedDays.length; i += 7) {
    weeks.push(paddedDays.slice(i, i + 7))
  }

  const dayLabels = ['S', 'M', 'T', 'W', 'T', 'F', 'S']

  return (
    <div className="overflow-x-auto">
      <div className="flex gap-1 min-w-max">
        {/* Day labels */}
        <div className="flex flex-col gap-1 mr-1 pt-6">
          {dayLabels.map((d, i) => (
            <div key={i} className="w-3 h-3 text-[9px] text-quest-muted flex items-center justify-center">
              {i % 2 === 1 ? d : ''}
            </div>
          ))}
        </div>

        {weeks.map((week, wi) => (
          <div key={wi} className="flex flex-col gap-1">
            {/* Month label for first week column (rough) */}
            {wi === 0 || (week[0] && week[0].slice(8) === '01') ? (
              <div className="h-5 text-[9px] text-quest-muted">
                {week[0] ? new Date(week[0]).toLocaleDateString('en', { month: 'short' }) : ''}
              </div>
            ) : (
              <div className="h-5" />
            )}

            {week.map((day, di) => {
              if (!day) return <div key={di} className="w-3 h-3" />
              const entry = dataMap[day]
              const xp = entry?.xp_earned ?? 0
              const lessons = entry?.lessons_completed ?? 0

              return (
                <div
                  key={di}
                  className={`w-3 h-3 rounded-sm transition-all duration-200 hover:ring-1 hover:ring-quest-purple cursor-default ${getIntensity(xp)}`}
                  title={`${day}: ${lessons} lesson${lessons !== 1 ? 's' : ''}, ${xp} XP`}
                />
              )
            })}
          </div>
        ))}
      </div>

      <div className="flex items-center gap-2 mt-2 text-xs text-quest-muted">
        <span>Less</span>
        {[0, 20, 40, 60, 80].map((xp) => (
          <div key={xp} className={`w-3 h-3 rounded-sm ${getIntensity(xp)}`} />
        ))}
        <span>More</span>
      </div>
    </div>
  )
}

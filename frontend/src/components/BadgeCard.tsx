import { motion } from 'framer-motion'
import type { Badge } from '../types'

interface Props {
  badge: Badge
  earned?: boolean
  size?: 'sm' | 'md' | 'lg'
}

const sizeMap = {
  sm: { card: 'p-3 gap-2', icon: 'text-2xl', name: 'text-xs', desc: 'text-xs' },
  md: { card: 'p-4 gap-3', icon: 'text-3xl', name: 'text-sm', desc: 'text-xs' },
  lg: { card: 'p-5 gap-3', icon: 'text-4xl', name: 'text-base', desc: 'text-sm' },
}

export default function BadgeCard({ badge, earned = true, size = 'md' }: Props) {
  const s = sizeMap[size]

  return (
    <motion.div
      whileHover={{ scale: 1.04, y: -2 }}
      className={`flex flex-col items-center text-center rounded-2xl border transition-all duration-200 ${s.card} ${
        earned
          ? 'bg-quest-card border-quest-purple/30 hover:border-quest-purple/60'
          : 'bg-quest-card/50 border-quest-border opacity-50 grayscale'
      }`}
      title={badge.description}
    >
      <span className={s.icon}>{badge.icon}</span>
      <div>
        <div className={`font-semibold text-quest-text ${s.name}`}>{badge.name}</div>
        <div className={`text-quest-muted ${s.desc} mt-0.5 leading-tight`}>{badge.description}</div>
        {badge.earned_at && (
          <div className="text-xs text-quest-purple/70 mt-1">
            {new Date(badge.earned_at).toLocaleDateString()}
          </div>
        )}
      </div>
    </motion.div>
  )
}

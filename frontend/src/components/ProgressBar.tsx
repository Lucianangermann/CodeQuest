import { motion } from 'framer-motion'

interface Props {
  value: number
  max: number
  label?: string
  color?: 'purple' | 'green' | 'yellow'
  showText?: boolean
  size?: 'sm' | 'md' | 'lg'
}

const colorMap = {
  purple: 'from-quest-purple to-quest-purple-light',
  green: 'from-quest-green to-emerald-400',
  yellow: 'from-yellow-500 to-amber-400',
}

const sizeMap = {
  sm: 'h-1.5',
  md: 'h-2.5',
  lg: 'h-4',
}

export default function ProgressBar({
  value,
  max,
  label,
  color = 'purple',
  showText = false,
  size = 'md',
}: Props) {
  const pct = max > 0 ? Math.min(100, Math.round((value / max) * 100)) : 0

  return (
    <div className="w-full">
      {(label || showText) && (
        <div className="flex justify-between items-center mb-1.5 text-sm text-quest-muted">
          {label && <span>{label}</span>}
          {showText && (
            <span>
              {value}/{max} ({pct}%)
            </span>
          )}
        </div>
      )}
      <div className={`bg-quest-border rounded-full overflow-hidden ${sizeMap[size]}`}>
        <motion.div
          initial={{ width: 0 }}
          animate={{ width: `${pct}%` }}
          transition={{ duration: 0.6, ease: 'easeOut' }}
          className={`h-full bg-gradient-to-r ${colorMap[color]} rounded-full`}
        />
      </div>
    </div>
  )
}

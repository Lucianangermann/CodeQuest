import { motion } from 'framer-motion'

interface Props {
  streak: number
  large?: boolean
}

export default function StreakDisplay({ streak, large = false }: Props) {
  return (
    <div className={`flex items-center gap-2 ${large ? '' : ''}`}>
      <motion.span
        animate={streak > 0 ? { scale: [1, 1.2, 1] } : {}}
        transition={{ repeat: Infinity, duration: 2, ease: 'easeInOut' }}
        className={large ? 'text-4xl' : 'text-xl'}
      >
        🔥
      </motion.span>
      <div>
        <span className={`font-bold text-quest-yellow ${large ? 'text-3xl' : 'text-lg'}`}>
          {streak}
        </span>
        {large && (
          <p className="text-quest-muted text-sm">
            {streak === 1 ? 'day streak' : 'day streak'}
          </p>
        )}
      </div>
    </div>
  )
}

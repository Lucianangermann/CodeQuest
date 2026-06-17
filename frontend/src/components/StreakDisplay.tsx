import { motion } from 'framer-motion'
import { useT } from '../i18n/useT'

interface Props {
  streak: number
  large?: boolean
}

export default function StreakDisplay({ streak, large = false }: Props) {
  const t = useT()
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
            {t('streak.days')}
          </p>
        )}
      </div>
    </div>
  )
}

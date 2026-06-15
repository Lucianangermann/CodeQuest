import { Link } from 'react-router-dom'
import { motion } from 'framer-motion'
import { useQuery } from '@tanstack/react-query'
import { BookOpen, Flame, Zap, Trophy, ChevronRight, Target, AlertCircle } from 'lucide-react'
import { fetchDashboard } from '../lib/api'
import ProgressBar from '../components/ProgressBar'
import BadgeCard from '../components/BadgeCard'
import Heatmap from '../components/Heatmap'
import StreakDisplay from '../components/StreakDisplay'
import { CardSkeleton } from '../components/LoadingSkeleton'

function StatCard({ icon, label, value, color = 'text-quest-purple' }: {
  icon: React.ReactNode; label: string; value: string | number; color?: string
}) {
  return (
    <motion.div whileHover={{ y: -2 }} className="card flex items-center gap-4">
      <div className={`${color} bg-current/10 rounded-xl p-3`}>{icon}</div>
      <div>
        <div className="text-2xl font-bold text-white">{value}</div>
        <div className="text-quest-muted text-sm">{label}</div>
      </div>
    </motion.div>
  )
}

export default function Dashboard() {
  const { data, isLoading, error } = useQuery({
    queryKey: ['dashboard'],
    queryFn: fetchDashboard,
  })

  const greeting = () => {
    const h = new Date().getHours()
    if (h < 12) return 'Good morning'
    if (h < 18) return 'Good afternoon'
    return 'Good evening'
  }

  if (isLoading) {
    return (
      <div className="max-w-7xl mx-auto px-4 py-8 space-y-6">
        <div className="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-4 gap-4">
          {[...Array(4)].map((_, i) => <CardSkeleton key={i} />)}
        </div>
        <CardSkeleton />
      </div>
    )
  }

  if (error || !data) {
    return (
      <div className="flex flex-col items-center justify-center min-h-[60vh] gap-3 text-quest-muted">
        <AlertCircle className="w-10 h-10 text-red-400" />
        <p>Could not load dashboard. Make sure the backend is running.</p>
      </div>
    )
  }

  const xpProgress = data.xp % 100

  return (
    <motion.div
      initial={{ opacity: 0, y: 12 }}
      animate={{ opacity: 1, y: 0 }}
      transition={{ duration: 0.3 }}
      className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-8 space-y-8"
    >
      <div className="flex items-center justify-between flex-wrap gap-4">
        <div>
          <h1 className="text-2xl sm:text-3xl font-bold text-white">
            {greeting()}, {data.username}! 👋
          </h1>
          <p className="text-quest-muted mt-1">Keep up the momentum — you're doing great!</p>
        </div>
        <StreakDisplay streak={data.streak} large />
      </div>

      <div className="grid grid-cols-2 lg:grid-cols-4 gap-4">
        <StatCard icon={<Zap className="w-5 h-5" />} label="Total XP" value={data.xp.toLocaleString()} color="text-quest-purple" />
        <StatCard icon={<Trophy className="w-5 h-5" />} label="Level" value={data.level} color="text-quest-yellow" />
        <StatCard icon={<BookOpen className="w-5 h-5" />} label="Lessons Done" value={data.total_lessons_completed} color="text-quest-green" />
        <StatCard icon={<Flame className="w-5 h-5" />} label="Day Streak" value={data.streak} color="text-orange-400" />
      </div>

      <div className="grid grid-cols-1 md:grid-cols-2 gap-6">
        <div className="card space-y-3">
          <div className="flex items-center justify-between">
            <h2 className="font-semibold text-white">Level Progress</h2>
            <span className="text-quest-muted text-sm">Lv. {data.level} → Lv. {data.level + 1}</span>
          </div>
          <ProgressBar value={xpProgress} max={100} showText />
          <p className="text-xs text-quest-muted">{100 - xpProgress} XP until next level</p>
        </div>

        <div className="card space-y-3">
          <div className="flex items-center justify-between">
            <div className="flex items-center gap-2">
              <Target className="w-4 h-4 text-quest-green" />
              <h2 className="font-semibold text-white">Daily Goal</h2>
            </div>
            <span className="text-quest-muted text-sm">{data.lessons_today} / {data.daily_goal} min</span>
          </div>
          <ProgressBar value={data.lessons_today * 5} max={data.daily_goal} color="green" />
          <p className="text-xs text-quest-muted">
            {data.xp_today > 0 ? `+${data.xp_today} XP earned today` : 'Start learning to earn XP!'}
          </p>
        </div>
      </div>

      {data.current_topic && (
        <motion.div
          whileHover={{ scale: 1.01 }}
          className="card bg-gradient-to-r from-quest-purple/20 to-quest-card border-quest-purple/30 flex items-center justify-between gap-4"
        >
          <div className="flex items-center gap-4">
            <span className="text-4xl">{data.current_topic.icon || '📚'}</span>
            <div>
              <p className="text-quest-muted text-sm">Continue learning</p>
              <h3 className="text-xl font-bold text-white">{data.current_topic.title}</h3>
              <ProgressBar value={data.current_topic.completed} max={data.current_topic.total} size="sm" />
              <p className="text-xs text-quest-muted mt-1">
                {data.current_topic.completed}/{data.current_topic.total} lessons
              </p>
            </div>
          </div>
          <Link to="/roadmap" className="btn-primary flex items-center gap-2 flex-shrink-0">
            Continue <ChevronRight className="w-4 h-4" />
          </Link>
        </motion.div>
      )}

      <div className="card">
        <h2 className="font-semibold text-white mb-4">Activity (Last 90 Days)</h2>
        <Heatmap data={data.activity_data} />
      </div>

      {data.recent_badges.length > 0 && (
        <div>
          <h2 className="font-semibold text-white mb-4">Recent Badges</h2>
          <div className="grid grid-cols-2 sm:grid-cols-3 gap-4">
            {data.recent_badges.map((badge) => (
              <BadgeCard key={badge.id} badge={badge} />
            ))}
          </div>
        </div>
      )}
    </motion.div>
  )
}

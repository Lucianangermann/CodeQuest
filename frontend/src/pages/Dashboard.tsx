import { useState } from 'react'
import { Link } from 'react-router-dom'
import { motion, AnimatePresence } from 'framer-motion'
import { useQuery } from '@tanstack/react-query'
import { BookOpen, Flame, Zap, Trophy, ChevronRight, Target, AlertCircle, Calendar, Clock } from 'lucide-react'
import { fetchDashboard, fetchTodaysTasks, fetchDailyChallenge } from '../lib/api'
import ProgressBar from '../components/ProgressBar'
import BadgeCard from '../components/BadgeCard'
import Heatmap from '../components/Heatmap'
import StreakDisplay from '../components/StreakDisplay'
import { CardSkeleton } from '../components/LoadingSkeleton'
import QuickPractice from '../components/QuickPractice'
import { useT } from '../i18n/useT'

function StatCard({ icon, label, value, color = 'text-quest-purple', gradient = 'from-quest-purple/8' }: {
  icon: React.ReactNode; label: string; value: string | number; color?: string; gradient?: string
}) {
  return (
    <motion.div whileHover={{ y: -2 }} className="card relative overflow-hidden flex items-center gap-4">
      <div className={`absolute inset-0 bg-gradient-to-br ${gradient} to-transparent rounded-2xl pointer-events-none`} />
      <div className={`${color} bg-current/10 rounded-xl p-3 relative`}>{icon}</div>
      <div className="relative">
        <div className="text-3xl font-extrabold text-white mt-1">{value}</div>
        <div className="text-quest-muted text-sm">{label}</div>
      </div>
    </motion.div>
  )
}

const LEAGUES = [
  { name: 'Rookie',     minXp: 0,     icon: '🌱', color: 'text-gray-400',    border: 'border-gray-400/30',    bg: 'bg-gray-400/10' },
  { name: 'Apprentice', minXp: 500,   icon: '⚡', color: 'text-blue-400',    border: 'border-blue-400/30',    bg: 'bg-blue-400/10' },
  { name: 'Developer',  minXp: 1500,  icon: '💻', color: 'text-green-400',   border: 'border-green-400/30',   bg: 'bg-green-400/10' },
  { name: 'Senior',     minXp: 3500,  icon: '🔥', color: 'text-orange-400',  border: 'border-orange-400/30',  bg: 'bg-orange-400/10' },
  { name: 'Architect',  minXp: 7000,  icon: '🏗️', color: 'text-purple-400',  border: 'border-purple-400/30',  bg: 'bg-purple-400/10' },
  { name: 'Legend',     minXp: 15000, icon: '👑', color: 'text-yellow-400',  border: 'border-yellow-400/30',  bg: 'bg-yellow-400/10' },
]
function getLeague(xp: number) {
  for (let i = LEAGUES.length - 1; i >= 0; i--) {
    if (xp >= LEAGUES[i].minXp) return LEAGUES[i]
  }
  return LEAGUES[0]
}

const ACTIVITY_COLORS: Record<string, string> = {
  theory: 'bg-blue-500/20 text-blue-300 border-blue-500/30',
  coding: 'bg-quest-purple/20 text-quest-purple border-quest-purple/30',
  interview_prep: 'bg-quest-yellow/20 text-quest-yellow border-quest-yellow/30',
  review: 'bg-quest-green/20 text-quest-green border-quest-green/30',
  project: 'bg-orange-500/20 text-orange-300 border-orange-500/30',
}

export default function Dashboard() {
  const t = useT()
  const [showQuickPractice, setShowQuickPractice] = useState(false)

  const { data, isLoading, error } = useQuery({
    queryKey: ['dashboard'],
    queryFn: fetchDashboard,
  })
  const { data: todayData } = useQuery({
    queryKey: ['today-tasks'],
    queryFn: fetchTodaysTasks,
    retry: false,
  })
  const { data: dailyChallenge } = useQuery({
    queryKey: ['daily-challenge'],
    queryFn: fetchDailyChallenge,
    retry: false,
    staleTime: 1000 * 60 * 60, // 1 hour
  })

  const greeting = () => {
    const h = new Date().getHours()
    if (h < 12) return t('dash.goodMorning')
    if (h < 18) return t('dash.goodAfternoon')
    return t('dash.goodEvening')
  }

  const ACTIVITY_TYPE_LABELS: Record<string, string> = {
    theory: t('dash.theory'),
    coding: t('dash.coding'),
    quiz: t('dash.quiz'),
    review: t('dash.review'),
    project: t('dash.project'),
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
        <p>{t('dash.loadError')}</p>
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
      {data && data.streak > 0 && data.lessons_today === 0 && (
        <motion.div
          initial={{ opacity: 0, y: -8 }}
          animate={{ opacity: 1, y: 0 }}
          className="mb-4 px-4 py-3 rounded-xl bg-orange-500/10 border border-orange-500/30 flex items-center gap-3"
        >
          <Flame className="w-5 h-5 text-orange-400 flex-shrink-0" />
          <span className="text-sm text-orange-300">
            <strong className="text-orange-400">{data.streak}{t('dash.daySuffix')}</strong> — {t('dash.streakAlert')} 🔥
          </span>
        </motion.div>
      )}

      <div className="flex items-center justify-between flex-wrap gap-4">
        <div>
          <h1 className="text-2xl sm:text-3xl font-bold">
            <span className="text-quest-text">{greeting()}, </span>
            <span style={{ background: 'linear-gradient(135deg, #9d5cf6 0%, #818cf8 100%)', WebkitBackgroundClip: 'text', WebkitTextFillColor: 'transparent', backgroundClip: 'text' }}>
              {data.username}
            </span>
            <span className="text-quest-text"> 👋</span>
          </h1>
          <p className="text-quest-muted mt-1">
            {data.total_lessons_completed === 0
              ? t('dash.welcomeFirst')
              : t('dash.keepGoing')}
          </p>
        </div>
        <StreakDisplay streak={data.streak} large />
      </div>

      <div className="grid grid-cols-2 lg:grid-cols-4 gap-4">
        <StatCard icon={<Zap className="w-5 h-5" />} label={t('dash.xp')} value={data.xp.toLocaleString()} color="text-quest-purple" gradient="from-quest-purple/10" />
        <StatCard icon={<Trophy className="w-5 h-5" />} label={t('dash.level')} value={data.level} color="text-quest-yellow" gradient="from-quest-indigo/10" />
        <StatCard icon={<BookOpen className="w-5 h-5" />} label={t('dash.lessonsDone')} value={data.total_lessons_completed} color="text-quest-green" gradient="from-quest-green/10" />
        <motion.div whileHover={{ y: -2 }} className="card relative overflow-hidden flex items-center gap-4">
          <div className="absolute inset-0 bg-gradient-to-br from-orange-500/10 to-transparent rounded-2xl pointer-events-none" />
          <div className="text-orange-400 bg-current/10 rounded-xl p-3 relative"><Flame className="w-5 h-5" /></div>
          <div className="relative flex-1">
            <div className="text-3xl font-extrabold text-white mt-1">{data.streak}</div>
            <div className="text-quest-muted text-sm flex items-center gap-1.5">
              {t('dash.streak')}
              {data.streak_shields > 0 && (
                <span className="inline-flex items-center gap-0.5 text-xs text-violet-300 bg-violet-500/20 border border-violet-500/30 rounded-full px-1.5 py-0.5 ml-1">
                  🛡️ {data.streak_shields}
                </span>
              )}
            </div>
          </div>
        </motion.div>
      </div>

      {(() => {
        const league = getLeague(data.xp)
        const next = LEAGUES.find(l => l.minXp > data.xp)
        return (
          <div className={`card flex items-center gap-3 py-3 border ${league.border} ${league.bg}`}>
            <span className="text-3xl">{league.icon}</span>
            <div className="flex-1">
              <p className="text-xs text-quest-muted uppercase tracking-wide">{t('dash.yourLeague')}</p>
              <p className={`font-bold text-lg ${league.color}`}>{league.name}</p>
            </div>
            {next && (
              <div className="text-right">
                <p className="text-xs text-quest-muted">{t('dash.nextLeague')}</p>
                <p className="text-xs text-quest-muted">{next.icon} {next.name} ({next.minXp - data.xp} XP)</p>
              </div>
            )}
          </div>
        )
      })()}

      {data.total_lessons_completed === 0 && (
        <motion.div
          initial={{ opacity: 0, y: 12 }}
          animate={{ opacity: 1, y: 0 }}
          className="card text-center py-10"
          style={{ background: 'linear-gradient(135deg, rgba(124,58,237,0.12) 0%, rgba(99,102,241,0.06) 100%)', borderColor: 'rgba(124,58,237,0.3)' }}
        >
          <div className="text-6xl mb-4">🚀</div>
          <h2 className="text-xl font-bold text-white mb-2">{t('dash.journeyStart')}</h2>
          <p className="text-quest-muted mb-6 max-w-sm mx-auto">
            {t('dash.emptyState')}
          </p>
          <Link to="/roadmap" className="btn-primary inline-flex items-center gap-2">
            {t('dash.goToRoadmap')} <ChevronRight className="w-4 h-4" />
          </Link>
        </motion.div>
      )}

      {data?.total_lessons !== undefined && data.total_lessons > 0 && (
        <div className="card">
          <div className="flex items-center justify-between mb-3">
            <div className="flex items-center gap-2">
              <BookOpen className="w-5 h-5 text-quest-purple" />
              <h3 className="font-semibold text-white text-sm">{t('dash.curriculumProgress')}</h3>
            </div>
            <span className="text-sm text-quest-muted">
              {data.total_lessons_completed}/{data.total_lessons} {t('road.lessons')}
            </span>
          </div>
          <div className="w-full bg-quest-border rounded-full h-2">
            <div
              className="bg-quest-purple h-2 rounded-full transition-all duration-700"
              style={{ width: `${Math.min(100, (data.total_lessons_completed / data.total_lessons) * 100)}%` }}
            />
          </div>
          <p className="text-xs text-quest-muted mt-2">
            {Math.round((data.total_lessons_completed / data.total_lessons) * 100)}% {t('dash.complete')}
          </p>
        </div>
      )}

      <div className="card flex items-center gap-4 cursor-pointer hover:border-quest-purple/40 transition-all"
        onClick={() => setShowQuickPractice(true)}>
        <div className="w-12 h-12 rounded-xl bg-quest-purple/20 flex items-center justify-center text-2xl flex-shrink-0">
          🧠
        </div>
        <div className="flex-1">
          <p className="font-semibold text-white text-sm">{t('dash.quickPractice')}</p>
          <p className="text-xs text-quest-muted">{t('dash.quickPracticeDesc')}</p>
        </div>
        <ChevronRight className="w-5 h-5 text-quest-muted" />
      </div>

      <div className="grid grid-cols-1 md:grid-cols-2 gap-6">
        <div className="card space-y-3">
          <div className="flex items-center justify-between">
            <h2 className="font-semibold text-white">{t('dash.levelProgress')}</h2>
            <span className="text-quest-muted text-sm">Lv. {data.level} → Lv. {data.level + 1}</span>
          </div>
          <ProgressBar value={xpProgress} max={100} showText />
          <p className="text-xs text-quest-muted">{100 - xpProgress} XP {t('dash.untilNextLevel')}</p>
        </div>

        <div className="card space-y-3">
          <div className="flex items-center justify-between">
            <div className="flex items-center gap-2">
              <Target className="w-4 h-4 text-quest-green" />
              <h2 className="font-semibold text-white">{t('dash.dailyGoal')}</h2>
            </div>
            <span className="text-quest-muted text-sm">{data.lessons_today} / {data.daily_goal} min</span>
          </div>
          <ProgressBar value={data.lessons_today * 5} max={data.daily_goal} color="green" />
          <p className="text-xs text-quest-muted">
            {data.xp_today > 0 ? `+${data.xp_today} ${t('dash.xpEarned')}` : 'Start learning to earn XP!'}
          </p>
        </div>
      </div>

      {data.next_badge && (
        <div className="card">
          <div className="flex items-center gap-3 mb-3">
            <span className="text-2xl">{data.next_badge.icon}</span>
            <div>
              <p className="text-xs text-quest-muted">Next Badge</p>
              <p className="font-semibold text-white text-sm">{data.next_badge.name}</p>
            </div>
            <span className="ml-auto text-xs text-quest-muted">{data.next_badge.goal_label}</span>
          </div>
          <div className="w-full bg-quest-border rounded-full h-2">
            <div
              className="bg-quest-yellow h-2 rounded-full transition-all duration-700"
              style={{ width: `${Math.min(100, data.next_badge.progress * 100)}%` }}
            />
          </div>
          <p className="text-xs text-quest-muted mt-1">{Math.round(data.next_badge.progress * 100)}% {t('dash.toUnlock')}</p>
        </div>
      )}

      {data.weak_topics && data.weak_topics.length > 0 && (
        <div className="card">
          <div className="flex items-center gap-2 mb-3">
            <span className="text-lg">⚠️</span>
            <h3 className="font-semibold text-white text-sm">{t('dash.weakTopics')}</h3>
            <span className="text-xs text-quest-muted ml-auto">{t('dash.practiceMore')} →</span>
          </div>
          <div className="space-y-2">
            {data.weak_topics.map((topic) => (
              <div key={topic.title} className="flex items-center gap-3 p-2.5 rounded-lg bg-red-500/5 border border-red-500/15">
                <span className="text-xl flex-shrink-0">{topic.icon || '📚'}</span>
                <div className="flex-1 min-w-0">
                  <p className="text-sm font-medium text-white truncate">{topic.title}</p>
                  <p className="text-xs text-quest-muted">Ø {topic.avg_attempts} {t('dash.attemptsPerLesson')}</p>
                </div>
                <Link to="/roadmap" className="text-xs text-quest-purple-light hover:underline flex-shrink-0">
                  {t('dash.practice')}
                </Link>
              </div>
            ))}
          </div>
          <p className="text-xs text-quest-muted mt-3">{t('dash.weakTopicsHint')}</p>
        </div>
      )}

      {data.current_topic && (
        <motion.div
          whileHover={{ scale: 1.01 }}
          className="card bg-gradient-to-r from-quest-purple/20 to-quest-card border-quest-purple/30 flex items-center justify-between gap-4"
        >
          <div className="flex items-center gap-4">
            <span className="text-4xl">{data.current_topic.icon || '📚'}</span>
            <div>
              <p className="text-quest-muted text-sm">Continue where you left off</p>
              <h3 className="text-xl font-bold text-white">{data.current_topic.title}</h3>
              {data.next_lesson && (
                <p className="text-xs text-quest-purple mt-0.5 truncate max-w-xs">{data.next_lesson.title}</p>
              )}
              <ProgressBar value={data.current_topic.completed} max={data.current_topic.total} size="sm" />
              <p className="text-xs text-quest-muted mt-1">
                {data.current_topic.completed}/{data.current_topic.total} {t('road.lessons')}
              </p>
            </div>
          </div>
          <Link
            to={data.next_lesson ? `/lesson/${data.next_lesson.id}` : '/roadmap'}
            className="btn-primary flex items-center gap-2 flex-shrink-0"
          >
            {data.next_lesson ? 'Start Lesson' : 'Continue'} <ChevronRight className="w-4 h-4" />
          </Link>
        </motion.div>
      )}

      {todayData && todayData.activities.length > 0 && (
        <div className="card space-y-4">
          <div className="flex items-center justify-between flex-wrap gap-2">
            <div className="flex items-center gap-2">
              <Calendar className="w-4 h-4 text-quest-purple" />
              <h2 className="font-semibold text-white">{t('dash.todaysTasks')}</h2>
              {todayData.phase_title && (
                <span className="text-xs text-quest-muted bg-quest-surface px-2 py-0.5 rounded-full">
                  {todayData.phase_title}
                </span>
              )}
            </div>
            {todayData.duration_minutes && (
              <span className="flex items-center gap-1 text-xs text-quest-muted">
                <Clock className="w-3 h-3" /> {todayData.duration_minutes} min
              </span>
            )}
          </div>
          <div className="space-y-2">
            {todayData.activities.map((act, i) => (
              <div
                key={i}
                className={`flex items-start gap-3 p-3 rounded-lg border ${ACTIVITY_COLORS[act.type] ?? 'bg-quest-surface border-quest-border text-quest-muted'}`}
              >
                <span className="text-xs font-medium mt-0.5 uppercase tracking-wider opacity-70 w-20 flex-shrink-0">
                  {ACTIVITY_TYPE_LABELS[act.type] ?? act.type.replace('_', ' ')}
                </span>
                <div className="min-w-0">
                  <p className="text-sm font-medium text-white truncate">{act.title}</p>
                  <p className="text-xs opacity-70 mt-0.5 truncate">{act.description}</p>
                </div>
              </div>
            ))}
          </div>
          <Link to="/training-plan" className="text-xs text-quest-purple hover:underline block">
            View full training plan →
          </Link>
        </div>
      )}

      {dailyChallenge && (
        <div className="card">
          <div className="flex items-center justify-between mb-3">
            <div className="flex items-center gap-2">
              <Target className="w-5 h-5 text-quest-yellow" />
              <h3 className="font-semibold text-white text-sm">{t('dash.dailyChallenge')}</h3>
              <span className="badge-pill bg-quest-yellow/20 text-quest-yellow text-xs">Today</span>
            </div>
            {dailyChallenge.is_completed && (
              <span className="text-xs text-quest-green font-medium">✓ {t('dash.complete')}</span>
            )}
          </div>
          <p className="text-sm text-white font-medium mb-1">{dailyChallenge.title}</p>
          <p className="text-xs text-quest-muted mb-3">{dailyChallenge.topic_title}</p>
          <a
            href={`/lesson/${dailyChallenge.id}`}
            className={`btn-primary text-sm inline-flex items-center gap-2 ${dailyChallenge.is_completed ? 'opacity-60' : ''}`}
          >
            {dailyChallenge.is_completed ? 'Review' : t('dash.startChallenge')} →
          </a>
        </div>
      )}

      <div className="card">
        <h2 className="font-semibold text-white mb-4">{t('dash.activityHeatmap')} (Last 90 Days)</h2>
        <Heatmap data={data.activity_data} />
      </div>

      {data.recent_badges.length > 0 && (
        <div>
          <h2 className="font-semibold text-white mb-4">{t('dash.recentBadges')}</h2>
          <div className="grid grid-cols-2 sm:grid-cols-3 gap-4">
            {data.recent_badges.map((badge) => (
              <BadgeCard key={badge.id} badge={badge} />
            ))}
          </div>
        </div>
      )}

      <AnimatePresence>
        {showQuickPractice && <QuickPractice onClose={() => setShowQuickPractice(false)} />}
      </AnimatePresence>
    </motion.div>
  )
}

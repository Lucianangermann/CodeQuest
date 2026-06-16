import { useState, useEffect } from 'react'
import { motion } from 'framer-motion'
import { useQuery, useMutation, useQueryClient } from '@tanstack/react-query'
import { Settings, BookOpen, Zap, Flame, Edit3, Check, X, AlertCircle, Bell } from 'lucide-react'
import { fetchProfile, updateProfile, fetchAllBadges, claimStreakShield, getVapidPublicKey, subscribeToPush, unsubscribeFromPush, fetchUserStats } from '../lib/api'
import { useUserStore } from '../store/useUserStore'
import { useT } from '../i18n/useT'
import type { ProfileData } from '../types'
import ProgressBar from '../components/ProgressBar'
import StreakDisplay from '../components/StreakDisplay'
import { CardSkeleton } from '../components/LoadingSkeleton'
import toast from 'react-hot-toast'

const LANGUAGES = ['python', 'javascript', 'typescript']

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

export default function Profile() {
  const { user, setUser, uiLanguage, setUiLanguage } = useUserStore()
  const t = useT()
  const queryClient = useQueryClient()
  const [editingGoal, setEditingGoal] = useState(false)
  const [goalValue, setGoalValue] = useState(user?.daily_goal ?? 30)
  const [notifEnabled, setNotifEnabled] = useState(false)
  const [notifSupported, setNotifSupported] = useState(false)

  const { data: profile, isLoading, error } = useQuery({
    queryKey: ['profile'],
    queryFn: fetchProfile,
    onSuccess: (data: ProfileData) => setGoalValue(data.daily_goal),
  } as Parameters<typeof useQuery>[0])

  const typedProfile = profile as ProfileData | undefined

  const { data: allBadges = [] } = useQuery({
    queryKey: ['all-badges'],
    queryFn: fetchAllBadges,
  })

  const { data: stats } = useQuery({
    queryKey: ['user-stats'],
    queryFn: fetchUserStats,
    retry: false,
  })

  const languageMutation = useMutation({
    mutationFn: (lang: string) => updateProfile({ language_preference: lang } as Partial<ProfileData>),
    onSuccess: (_, lang) => {
      queryClient.setQueryData<ProfileData>(['profile'], (old) =>
        old ? { ...old, language_preference: lang } : old
      )
      if (user) setUser({ ...user, language_preference: lang })
      toast.success(`Language set to ${lang}`)
    },
    onError: () => toast.error('Could not update language'),
  })

  const goalMutation = useMutation({
    mutationFn: (goal: number) => updateProfile({ daily_goal: goal } as Partial<ProfileData>),
    onSuccess: (_, goal) => {
      queryClient.setQueryData<ProfileData>(['profile'], (old) =>
        old ? { ...old, daily_goal: goal } : old
      )
      if (user) setUser({ ...user, daily_goal: goal })
      setEditingGoal(false)
      toast.success('Daily goal updated!')
    },
    onError: () => toast.error('Could not update goal'),
  })

  const claimShieldMutation = useMutation({
    mutationFn: claimStreakShield,
    onSuccess: (result) => {
      queryClient.setQueryData<ProfileData>(['profile'], (old) =>
        old ? { ...old, streak_shields: result.shields } : old
      )
      if (user) setUser({ ...user, streak_shields: result.shields })
      toast.success(result.message)
    },
    onError: (err: { response?: { data?: { detail?: string } } }) => {
      toast.error(err?.response?.data?.detail || 'Could not claim shield')
    },
  })

  useEffect(() => {
    if (!('Notification' in window) || !('serviceWorker' in navigator)) return
    setNotifSupported(true)
    navigator.serviceWorker.ready.then(reg => {
      reg.pushManager.getSubscription().then(sub => {
        setNotifEnabled(!!sub)
      })
    })
  }, [])

  async function enableNotifications() {
    const permission = await Notification.requestPermission()
    if (permission !== 'granted') {
      toast.error('Notification permission denied.')
      return
    }
    const reg = await navigator.serviceWorker.ready
    const vapidKey = await getVapidPublicKey()
    // Convert base64url to Uint8Array for applicationServerKey
    const keyBytes = Uint8Array.from(
      atob(vapidKey.replace(/-/g, '+').replace(/_/g, '/')),
      c => c.charCodeAt(0)
    )
    const sub = await reg.pushManager.subscribe({
      userVisibleOnly: true,
      applicationServerKey: keyBytes,
    })
    const subJson = sub.toJSON()
    await subscribeToPush({
      endpoint: subJson.endpoint!,
      p256dh: subJson.keys!.p256dh,
      auth: subJson.keys!.auth,
    })
    setNotifEnabled(true)
    toast.success("Notifications enabled! You'll be reminded at 8 PM if you forget to practice.")
  }

  async function disableNotifications() {
    const reg = await navigator.serviceWorker.ready
    const sub = await reg.pushManager.getSubscription()
    if (sub) {
      const subJson = sub.toJSON()
      await unsubscribeFromPush({
        endpoint: subJson.endpoint!,
        p256dh: subJson.keys!.p256dh,
        auth: subJson.keys!.auth,
      })
      await sub.unsubscribe()
    }
    setNotifEnabled(false)
    toast.success('Notifications disabled.')
  }

  if (isLoading) {
    return (
      <div className="max-w-3xl mx-auto px-4 py-8 space-y-6">
        <CardSkeleton />
        <CardSkeleton />
      </div>
    )
  }

  if (error || !typedProfile) {
    return (
      <div className="flex flex-col items-center justify-center min-h-[60vh] gap-3 text-quest-muted">
        <AlertCircle className="w-10 h-10 text-red-400" />
        <p>Could not load profile.</p>
      </div>
    )
  }

  const xpProgress = typedProfile.xp % 100

  return (
    <motion.div
      initial={{ opacity: 0, y: 12 }}
      animate={{ opacity: 1, y: 0 }}
      transition={{ duration: 0.3 }}
      className="max-w-3xl mx-auto px-4 sm:px-6 py-8 space-y-6"
    >
      {/* Profile header */}
      <div className="card flex items-center gap-6 flex-wrap">
        <div className="w-20 h-20 rounded-2xl bg-quest-purple/30 border-2 border-quest-purple flex items-center justify-center text-3xl font-bold text-white flex-shrink-0 overflow-hidden">
          {typedProfile.avatar_url
            ? <img src={typedProfile.avatar_url} alt={typedProfile.username} className="w-full h-full object-cover" />
            : typedProfile.username.charAt(0).toUpperCase()}
        </div>
        <div className="flex-1 min-w-0">
          <h1 className="text-2xl font-bold text-white">{typedProfile.username}</h1>
          <div className="flex items-center gap-4 mt-2 flex-wrap">
            <div className="flex items-center gap-1.5 text-quest-purple-light text-sm">
              <Zap className="w-4 h-4" />
              Level {typedProfile.level}
            </div>
            <div className="flex items-center gap-1.5 text-quest-muted text-sm">
              <BookOpen className="w-4 h-4" />
              {typedProfile.total_lessons_completed} lessons
            </div>
            <StreakDisplay streak={typedProfile.streak} />
            {(() => {
              const league = getLeague(typedProfile.xp)
              return (
                <span className={`inline-flex items-center gap-1.5 text-xs font-semibold px-2.5 py-1 rounded-full border ${league.border} ${league.bg} ${league.color}`}>
                  {league.icon} {league.name}
                </span>
              )
            })()}
          </div>
          <div className="mt-3">
            <ProgressBar value={xpProgress} max={100} label={`${typedProfile.xp} XP total`} size="sm" />
          </div>
        </div>
      </div>

      {/* Stats */}
      <div className="grid grid-cols-3 gap-4">
        {[
          { icon: <Zap className="w-5 h-5" />, label: t('profile.stats') + ' XP', value: typedProfile.xp.toLocaleString(), color: 'text-quest-purple' },
          { icon: <BookOpen className="w-5 h-5" />, label: 'Lessons', value: typedProfile.total_lessons_completed, color: 'text-quest-green' },
          { icon: <Flame className="w-5 h-5" />, label: 'Streak', value: `${typedProfile.streak}d`, color: 'text-orange-400' },
        ].map(({ icon, label, value, color }) => (
          <div key={label} className="card text-center">
            <div className={`${color} mx-auto mb-1`}>{icon}</div>
            <div className="text-xl font-bold text-white">{value}</div>
            <div className="text-xs text-quest-muted">{label}</div>
          </div>
        ))}
      </div>

      {/* Settings */}
      <div className="card space-y-6">
        <div className="flex items-center gap-2">
          <Settings className="w-5 h-5 text-quest-muted" />
          <h2 className="font-semibold text-white">Settings</h2>
        </div>

        {/* App Language */}
        <div>
          <label className="text-sm font-medium text-quest-text mb-3 block">{t('profile.uiLanguage')}</label>
          <div className="flex gap-2">
            <button
              onClick={() => setUiLanguage('en')}
              className={`px-4 py-2 rounded-lg text-sm font-medium border transition-all ${
                uiLanguage === 'en'
                  ? 'bg-quest-purple border-quest-purple text-white'
                  : 'bg-quest-card border-quest-border text-quest-muted hover:border-quest-purple/50 hover:text-quest-text'
              }`}
            >
              English
            </button>
            <button
              onClick={() => setUiLanguage('de')}
              className={`px-4 py-2 rounded-lg text-sm font-medium border transition-all ${
                uiLanguage === 'de'
                  ? 'bg-quest-purple border-quest-purple text-white'
                  : 'bg-quest-card border-quest-border text-quest-muted hover:border-quest-purple/50 hover:text-quest-text'
              }`}
            >
              Deutsch
            </button>
          </div>
        </div>

        {/* Coding Language */}
        <div>
          <label className="text-sm font-medium text-quest-text mb-3 block">{t('profile.codingLanguage')}</label>
          <div className="flex flex-wrap gap-2">
            {LANGUAGES.map((lang) => (
              <button
                key={lang}
                onClick={() => languageMutation.mutate(lang)}
                disabled={languageMutation.isPending}
                className={`px-3 py-1.5 rounded-lg text-sm font-medium border transition-all disabled:opacity-60 ${
                  typedProfile.language_preference === lang
                    ? 'bg-quest-purple border-quest-purple text-white'
                    : 'bg-quest-card border-quest-border text-quest-muted hover:border-quest-purple/50 hover:text-quest-text'
                }`}
              >
                {lang}
              </button>
            ))}
          </div>
        </div>

        {/* Daily goal */}
        <div>
          <div className="flex items-center justify-between mb-2">
            <label className="text-sm font-medium text-quest-text">Daily Goal (minutes)</label>
            {!editingGoal ? (
              <button onClick={() => setEditingGoal(true)} className="text-quest-muted hover:text-quest-text transition-colors">
                <Edit3 className="w-4 h-4" />
              </button>
            ) : (
              <div className="flex items-center gap-2">
                <button
                  onClick={() => goalMutation.mutate(goalValue)}
                  disabled={goalMutation.isPending}
                  className="text-quest-green hover:text-green-400 transition-colors disabled:opacity-50"
                >
                  <Check className="w-4 h-4" />
                </button>
                <button
                  onClick={() => { setEditingGoal(false); setGoalValue(typedProfile.daily_goal) }}
                  className="text-quest-muted hover:text-red-400 transition-colors"
                >
                  <X className="w-4 h-4" />
                </button>
              </div>
            )}
          </div>
          {editingGoal ? (
            <input
              type="number"
              value={goalValue}
              onChange={(e) => setGoalValue(Number(e.target.value))}
              min={5} max={240} step={5}
              className="input w-32"
            />
          ) : (
            <p className="text-2xl font-bold text-white">{typedProfile.daily_goal} min</p>
          )}
        </div>

        {/* Streak Shields */}
        <div>
          <div className="flex items-center justify-between mb-2">
            <label className="text-sm font-medium text-quest-text">{t('profile.streakShields')}</label>
            <span className="text-xs text-quest-muted">New shield every Monday</span>
          </div>
          <div className="flex items-center gap-4 flex-wrap">
            <p className="text-2xl font-bold text-white">
              🛡️ {typedProfile.streak_shields ?? 0} / 3
            </p>
            <button
              onClick={() => claimShieldMutation.mutate()}
              disabled={claimShieldMutation.isPending || (typedProfile.streak_shields ?? 0) >= 3}
              className="btn-secondary text-sm disabled:opacity-50 disabled:cursor-not-allowed"
            >
              {claimShieldMutation.isPending ? 'Claiming...' : t('profile.claimShield')}
            </button>
          </div>
          <p className="text-xs text-quest-muted mt-2">
            {t('profile.shieldDesc')}
          </p>
        </div>

        {/* Daily Reminders */}
        {notifSupported && (
          <div className="pt-4 border-t border-quest-border">
            <div className="flex items-center justify-between mb-2">
              <div>
                <h3 className="font-semibold text-white text-sm">{t('profile.dailyReminders')}</h3>
                <p className="text-xs text-quest-muted">{t('profile.reminderDesc')}</p>
              </div>
              <Bell className="w-5 h-5 text-quest-muted" />
            </div>
            {notifEnabled ? (
              <div className="flex items-center justify-between">
                <span className="text-xs text-quest-green">✓ Reminders enabled</span>
                <button onClick={disableNotifications} className="text-xs text-quest-muted hover:text-red-400 transition-colors">
                  {t('profile.disableReminders')}
                </button>
              </div>
            ) : (
              <button onClick={enableNotifications} className="btn-secondary text-sm w-full">
                {t('profile.enableReminders')} 🔔
              </button>
            )}
            {Notification.permission === 'denied' && (
              <p className="text-xs text-red-400 mt-1">Notifications blocked in browser settings. Allow them to enable reminders.</p>
            )}
          </div>
        )}
      </div>

      {/* Lernstatistiken */}
      {stats && (
        <div className="card space-y-4">
          <h3 className="font-bold text-white text-lg">📊 Lernstatistiken</h3>
          <div className="grid grid-cols-2 sm:grid-cols-3 gap-3">
            <div className="bg-quest-surface rounded-xl p-3 text-center border border-quest-border/50">
              <p className="text-2xl font-bold text-white">{stats.study_days}</p>
              <p className="text-xs text-quest-muted mt-0.5">Lerntage</p>
            </div>
            <div className="bg-quest-surface rounded-xl p-3 text-center border border-quest-border/50">
              <p className="text-2xl font-bold text-quest-green">{stats.first_attempt_rate}%</p>
              <p className="text-xs text-quest-muted mt-0.5">Ersttreffer-Rate</p>
            </div>
            <div className="bg-quest-surface rounded-xl p-3 text-center border border-quest-border/50">
              <p className="text-2xl font-bold text-quest-purple">{stats.avg_xp_per_study_day}</p>
              <p className="text-xs text-quest-muted mt-0.5">Ø XP / Tag</p>
            </div>
          </div>

          {stats.best_topic && (
            <div className="flex items-center gap-3 p-3 rounded-xl bg-quest-yellow/5 border border-quest-yellow/20">
              <span className="text-2xl">{stats.best_topic.icon || '🏆'}</span>
              <div>
                <p className="text-xs text-quest-muted">Bestes Thema</p>
                <p className="text-sm font-semibold text-white">{stats.best_topic.title}</p>
                <p className="text-xs text-quest-muted">{stats.best_topic.count} Lektionen abgeschlossen</p>
              </div>
            </div>
          )}

          <div className="grid grid-cols-2 gap-3 text-sm">
            {stats.best_weekday && (
              <div className="bg-quest-surface rounded-xl p-3 border border-quest-border/50">
                <p className="text-xs text-quest-muted mb-1">Aktivster Tag</p>
                <p className="font-semibold text-white">📅 {stats.best_weekday}</p>
              </div>
            )}
            {stats.member_since && (
              <div className="bg-quest-surface rounded-xl p-3 border border-quest-border/50">
                <p className="text-xs text-quest-muted mb-1">Mitglied seit</p>
                <p className="font-semibold text-white">🗓️ {stats.member_since}</p>
              </div>
            )}
          </div>

          {Object.keys(stats.lessons_by_type).length > 0 && (
            <div>
              <p className="text-xs text-quest-muted uppercase tracking-wide mb-2">Lektionen nach Typ</p>
              <div className="flex gap-2 flex-wrap">
                {Object.entries(stats.lessons_by_type).map(([type, count]) => (
                  <span key={type} className="text-xs px-2.5 py-1 rounded-full bg-quest-surface border border-quest-border/50 text-quest-text">
                    {type === 'theory' ? '📖' : type === 'quiz' ? '🧠' : '💻'} {count as number} {type}
                  </span>
                ))}
              </div>
            </div>
          )}
        </div>
      )}

      {/* Badge Encyclopedia */}
      <div className="card">
        <h3 className="font-bold text-white text-lg mb-4">Achievements</h3>
        {allBadges.length === 0 ? (
          <p className="text-quest-muted text-sm">Loading badges...</p>
        ) : (
          <div className="grid grid-cols-2 sm:grid-cols-3 md:grid-cols-4 gap-3">
            {allBadges.map((badge) => (
              <div
                key={badge.id}
                className={`flex flex-col items-center gap-2 p-4 rounded-2xl border text-center transition-all duration-200 ${
                  badge.earned
                    ? 'border-quest-yellow/40 bg-gradient-to-b from-quest-yellow/10 to-quest-yellow/3 shadow-[0_0_16px_rgba(234,179,8,0.12)]'
                    : 'border-quest-border/50 bg-quest-card/50 opacity-50 grayscale'
                }`}
              >
                <span className="text-3xl" style={badge.earned ? { filter: 'drop-shadow(0 0 8px rgba(234,179,8,0.4))' } : {}}>{badge.icon}</span>
                <span className={`text-xs font-semibold leading-tight ${badge.earned ? 'text-white' : 'text-quest-muted'}`}>
                  {badge.name}
                </span>
                <span className="text-xs text-quest-muted leading-tight">{badge.description}</span>
                {badge.earned ? (
                  <span className="text-xs text-quest-yellow font-medium">✓ Earned</span>
                ) : badge.progress !== null && badge.goal !== null ? (
                  <div className="w-full">
                    <div className="flex justify-between text-xs text-quest-muted mb-1">
                      <span>{badge.progress}</span>
                      <span>{badge.goal}</span>
                    </div>
                    <div className="w-full bg-quest-border rounded-full h-1">
                      <div
                        className="bg-quest-purple h-1 rounded-full"
                        style={{ width: `${Math.min(100, (badge.progress / badge.goal) * 100)}%` }}
                      />
                    </div>
                  </div>
                ) : (
                  <span className="text-xs text-quest-muted">🔒 Locked</span>
                )}
              </div>
            ))}
          </div>
        )}
      </div>
    </motion.div>
  )
}

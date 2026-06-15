import { useState } from 'react'
import { motion } from 'framer-motion'
import { useQuery, useMutation, useQueryClient } from '@tanstack/react-query'
import { Settings, BookOpen, Zap, Flame, Edit3, Check, X, AlertCircle } from 'lucide-react'
import { fetchProfile, updateProfile, fetchAllBadges } from '../lib/api'
import { useUserStore } from '../store/useUserStore'
import type { ProfileData } from '../types'
import ProgressBar from '../components/ProgressBar'
import StreakDisplay from '../components/StreakDisplay'
import { CardSkeleton } from '../components/LoadingSkeleton'
import toast from 'react-hot-toast'

const LANGUAGES = ['python', 'javascript', 'typescript']

export default function Profile() {
  const { user, setUser } = useUserStore()
  const queryClient = useQueryClient()
  const [editingGoal, setEditingGoal] = useState(false)
  const [goalValue, setGoalValue] = useState(user?.daily_goal ?? 30)

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
          </div>
          <div className="mt-3">
            <ProgressBar value={xpProgress} max={100} label={`${typedProfile.xp} XP total`} size="sm" />
          </div>
        </div>
      </div>

      {/* Stats */}
      <div className="grid grid-cols-3 gap-4">
        {[
          { icon: <Zap className="w-5 h-5" />, label: 'Total XP', value: typedProfile.xp.toLocaleString(), color: 'text-quest-purple' },
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

        {/* Language */}
        <div>
          <label className="text-sm font-medium text-quest-text mb-3 block">Preferred Language</label>
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
      </div>

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
                className={`flex flex-col items-center gap-2 p-3 rounded-xl border text-center transition-all ${
                  badge.earned
                    ? 'border-quest-yellow/40 bg-quest-yellow/5'
                    : 'border-quest-border bg-quest-border/20 opacity-60 grayscale'
                }`}
              >
                <span className="text-3xl">{badge.icon}</span>
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

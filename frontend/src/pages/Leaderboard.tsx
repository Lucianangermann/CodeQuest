import { motion } from 'framer-motion'
import { useQuery } from '@tanstack/react-query'
import { Trophy, Medal, Crown, AlertCircle } from 'lucide-react'
import { fetchLeaderboard } from '../lib/api'
import type { LeaderboardEntry } from '../types'
import { ListSkeleton } from '../components/LoadingSkeleton'
import { useT } from '../i18n/useT'

function RankIcon({ rank }: { rank: number }) {
  if (rank === 1) return <Crown className="w-5 h-5 text-yellow-400" />
  if (rank === 2) return <Medal className="w-5 h-5 text-gray-300" />
  if (rank === 3) return <Medal className="w-5 h-5 text-amber-600" />
  return <span className="text-quest-muted font-mono text-sm w-5 text-center">{rank}</span>
}

function Avatar({ entry }: { entry: LeaderboardEntry }) {
  return (
    <div className={`w-9 h-9 rounded-full bg-quest-border flex items-center justify-center text-sm font-bold text-quest-text flex-shrink-0 ${
      entry.is_current_user ? 'ring-2 ring-quest-purple' : ''
    }`}>
      {entry.avatar_url ? (
        <img src={entry.avatar_url} alt={entry.username} className="w-full h-full rounded-full object-cover" />
      ) : (
        entry.username.charAt(0).toUpperCase()
      )}
    </div>
  )
}

export default function Leaderboard() {
  const t = useT()
  const { data: entries = [], isLoading, error } = useQuery({
    queryKey: ['leaderboard'],
    queryFn: fetchLeaderboard,
    staleTime: 5 * 60_000,
  })

  return (
    <motion.div
      initial={{ opacity: 0, y: 12 }}
      animate={{ opacity: 1, y: 0 }}
      transition={{ duration: 0.3 }}
      className="max-w-2xl mx-auto px-4 sm:px-6 py-8"
    >
      <div className="flex items-center gap-3 mb-8">
        <Trophy className="w-7 h-7 text-quest-yellow" />
        <div>
          <h1 className="text-3xl font-bold text-white">{t('lb.title')}</h1>
          <p className="text-quest-muted text-sm">{t('lb.subtitle')}</p>
        </div>
      </div>

      {error && (
        <div className="flex items-center gap-2 text-red-400 mb-6">
          <AlertCircle className="w-4 h-4" />
          <span className="text-sm">{t('lb.loadError')}</span>
        </div>
      )}

      {/* Podium */}
      {!isLoading && entries.length >= 3 && (
        <div className="flex items-end justify-center gap-4 mb-10">
          {[entries[1], entries[0], entries[2]].map((entry, i) => {
            const heights = ['h-20', 'h-28', 'h-20']
            const colors = [
              'bg-gray-400/20 border-gray-400/30',
              'bg-yellow-400/20 border-yellow-400/30',
              'bg-amber-600/20 border-amber-600/30',
            ]
            const labels = ['2', '🥇', '3']
            return (
              <div key={entry.user_id} className="flex flex-col items-center gap-2">
                <div className={`w-12 h-12 rounded-full bg-quest-border flex items-center justify-center text-xl overflow-hidden ${
                  entry.is_current_user ? 'ring-2 ring-quest-purple' : ''
                }`}>
                  {entry.avatar_url
                    ? <img src={entry.avatar_url} alt="" className="w-full h-full object-cover" />
                    : entry.username.charAt(0).toUpperCase()}
                </div>
                <span className="text-xs font-medium text-quest-text max-w-[80px] truncate">{entry.username}</span>
                <span className="text-xs text-quest-muted">{entry.weekly_xp} XP</span>
                <div className={`w-20 ${heights[i]} rounded-t-xl border ${colors[i]} flex items-end justify-center pb-2 text-lg font-bold`}>
                  {labels[i]}
                </div>
              </div>
            )
          })}
        </div>
      )}

      <div className="space-y-2">
        {isLoading ? (
          <ListSkeleton count={8} />
        ) : entries.length === 0 ? (
          <div className="card text-center py-12">
            <Trophy className="w-12 h-12 text-quest-border mx-auto mb-3" />
            <p className="text-quest-muted">{t('lb.noActivity')}</p>
          </div>
        ) : (
          entries.map((entry, i) => (
            <motion.div
              key={entry.user_id}
              initial={{ opacity: 0, x: -12 }}
              animate={{ opacity: 1, x: 0 }}
              transition={{ delay: i * 0.04 }}
              className={`flex items-center gap-4 px-4 py-3 rounded-xl border transition-all ${
                entry.is_current_user
                  ? 'bg-quest-purple/10 border-quest-purple/40'
                  : 'bg-quest-card border-quest-border'
              }`}
            >
              <div className="w-8 flex-shrink-0 flex justify-center">
                <RankIcon rank={entry.rank} />
              </div>
              <Avatar entry={entry} />
              <div className="flex-1 min-w-0">
                <span className={`font-semibold truncate block ${entry.is_current_user ? 'text-quest-purple-light' : 'text-white'}`}>
                  {entry.username}
                  {entry.is_current_user && <span className="text-xs text-quest-muted ml-2">({t('lb.you')})</span>}
                </span>
              </div>
              <div className="text-right flex-shrink-0">
                <span className="font-bold text-white">{entry.weekly_xp}</span>
                <span className="text-quest-muted text-xs ml-1">XP</span>
              </div>
            </motion.div>
          ))
        )}
      </div>
    </motion.div>
  )
}

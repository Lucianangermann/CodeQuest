import { useState } from 'react'
import { useNavigate } from 'react-router-dom'
import { motion } from 'framer-motion'
import { useQuery, useQueryClient } from '@tanstack/react-query'
import { Lock, CheckCircle, ChevronRight, AlertCircle, Search, X } from 'lucide-react'
import { fetchTopics, fetchTopicLessons, updateProfile } from '../lib/api'
import { useLessonStore } from '../store/useLessonStore'
import { useUserStore } from '../store/useUserStore'
import { useT } from '../i18n/useT'
import type { Topic, Lesson, ProfileData } from '../types'
import { ListSkeleton, TopicNodeSkeleton } from '../components/LoadingSkeleton'
import ProgressBar from '../components/ProgressBar'

const LANGUAGES = [
  { value: 'python',     label: 'Python',     emoji: '🐍' },
  { value: 'javascript', label: 'JavaScript', emoji: '⚡' },
  { value: 'typescript', label: 'TypeScript', emoji: '🔷' },
]

function TopicNode({ topic, isSelected, onSelect }: {
  topic: Topic; isSelected: boolean; onSelect: () => void
}) {
  const statusColor = topic.is_completed
    ? 'border-quest-green/50 bg-gradient-to-b from-quest-green/15 to-quest-green/5 text-quest-green'
    : topic.is_locked
    ? 'border-quest-border bg-quest-border/30 text-quest-muted'
    : isSelected
    ? 'border-quest-purple/60 bg-gradient-to-b from-quest-purple/20 to-quest-purple/5 text-quest-purple-light'
    : 'border-quest-border bg-quest-card text-quest-text hover:border-quest-purple/40 hover:shadow-[0_0_12px_rgba(124,58,237,0.15)]'

  return (
    <motion.button
      whileHover={!topic.is_locked ? { scale: 1.03 } : {}}
      whileTap={!topic.is_locked ? { scale: 0.98 } : {}}
      onClick={topic.is_locked ? undefined : onSelect}
      style={topic.is_completed ? { boxShadow: '0 0 16px rgba(34,197,94,0.15)' } : isSelected ? { boxShadow: '0 0 16px rgba(124,58,237,0.2)' } : {}}
      className={`relative flex flex-col items-center gap-2 p-4 rounded-2xl border-2 transition-all duration-200 w-28 ${statusColor} ${
        topic.is_locked ? 'cursor-not-allowed' : 'cursor-pointer'
      }`}
    >
      <span className="text-3xl">{topic.icon || '📚'}</span>
      <span className="text-xs font-semibold text-center leading-tight">{topic.title}</span>
      {topic.is_completed && (
        <CheckCircle className="absolute -top-2 -right-2 w-5 h-5 text-quest-green bg-quest-bg rounded-full" />
      )}
      {topic.is_locked && (
        <Lock className="absolute -top-2 -right-2 w-4 h-4 text-quest-muted bg-quest-bg rounded-full p-0.5" />
      )}
    </motion.button>
  )
}

export default function Roadmap() {
  const navigate = useNavigate()
  const { setCurrentLesson } = useLessonStore()
  const [selectedTopicId, setSelectedTopicId] = useState<number | null>(null)
  const [search, setSearch] = useState('')
  const { user, setUser } = useUserStore()
  const queryClient = useQueryClient()
  const t = useT()
  const lang = user?.language_preference || 'python'

  async function handleLangChange(newLang: string) {
    if (!user || newLang === lang) return
    setSelectedTopicId(null)
    setUser({ ...user, language_preference: newLang })
    await updateProfile({ language_preference: newLang } as Partial<ProfileData>)
    queryClient.invalidateQueries({ queryKey: ['topics'] })
  }

  const TYPE_LABELS: Record<string, string> = {
    theory: t('road.theory'),
    quiz: t('road.quiz'),
    code: t('road.code'),
  }

  const { data: topics = [], isLoading: loadingTopics, error: topicsError } = useQuery({
    queryKey: ['topics', lang],
    queryFn: () => fetchTopics(lang),
    staleTime: 1000 * 60 * 5,
    select: (data) => {
      // Auto-select first non-locked topic on initial load
      if (selectedTopicId === null && data.length > 0) {
        const first = data.find((t) => !t.is_locked && !t.is_completed) || data[0]
        setSelectedTopicId(first.id)
      }
      return data
    },
  })

  const filteredTopics = search
    ? (topics ?? []).filter(t => t.title.toLowerCase().includes(search.toLowerCase()))
    : (topics ?? [])

  const selectedTopic = topics.find((t) => t.id === selectedTopicId) ?? null

  const { data: lessons = [], isLoading: loadingLessons } = useQuery({
    queryKey: ['topic-lessons', selectedTopicId, lang],
    queryFn: () => fetchTopicLessons(selectedTopicId!, lang),
    enabled: selectedTopicId !== null,
  })

  function handleStartLesson(lesson: Lesson) {
    if (!selectedTopic) return
    setCurrentLesson(lesson, selectedTopic.title)
    navigate(`/lesson/${lesson.id}`)
  }

  if (topicsError) {
    return (
      <div className="flex flex-col items-center justify-center min-h-[60vh] gap-3 text-quest-muted">
        <AlertCircle className="w-10 h-10 text-red-400" />
        <p>{t('road.loadError')}</p>
      </div>
    )
  }

  return (
    <motion.div
      initial={{ opacity: 0, y: 12 }}
      animate={{ opacity: 1, y: 0 }}
      transition={{ duration: 0.3 }}
      className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-8"
    >
      <div className="mb-8 flex flex-col sm:flex-row sm:items-center sm:justify-between gap-4">
        <div>
          <h1 className="text-3xl font-bold text-white">{t('road.title')}</h1>
          <p className="text-quest-muted mt-1">{t('road.subtitle')}</p>
        </div>
        {/* Language switcher */}
        <div className="flex items-center gap-1 p-1 rounded-xl bg-quest-card border border-quest-border">
          {LANGUAGES.map(({ value, label, emoji }) => (
            <button
              key={value}
              onClick={() => handleLangChange(value)}
              className={`flex items-center gap-1.5 px-3 py-1.5 rounded-lg text-sm font-medium transition-all ${
                lang === value
                  ? 'bg-quest-purple text-white shadow'
                  : 'text-quest-muted hover:text-quest-text hover:bg-white/5'
              }`}
            >
              <span>{emoji}</span>
              <span className="hidden sm:inline">{label}</span>
            </button>
          ))}
        </div>
      </div>

      <div className="flex flex-col lg:flex-row gap-8">
        {/* Topic nodes */}
        <div className="lg:w-auto">
          <h2 className="text-sm font-semibold text-quest-muted uppercase tracking-wide mb-4">{t('road.topics')}</h2>
          <div className="relative mb-4">
            <Search className="absolute left-3 top-1/2 -translate-y-1/2 w-4 h-4 text-quest-muted" />
            <input
              type="text"
              placeholder={t('road.searchPlaceholder')}
              value={search}
              onChange={e => setSearch(e.target.value)}
              className="input pl-10 py-2.5 text-sm"
            />
            {search && (
              <button onClick={() => setSearch('')} className="absolute right-3 top-1/2 -translate-y-1/2 text-quest-muted hover:text-quest-text">
                <X className="w-4 h-4" />
              </button>
            )}
          </div>
          {loadingTopics ? (
            <div className="flex flex-wrap gap-3">
              {[...Array(6)].map((_, i) => <TopicNodeSkeleton key={i} />)}
            </div>
          ) : filteredTopics.length === 0 ? (
            <div className="text-center py-12 text-quest-muted">
              <p>{t('road.noTopics')} for "{search}"</p>
            </div>
          ) : (
            <div className="flex flex-wrap lg:flex-col gap-3">
              {filteredTopics.map((topic) => (
                <TopicNode
                  key={topic.id}
                  topic={topic}
                  isSelected={selectedTopicId === topic.id}
                  onSelect={() => setSelectedTopicId(topic.id)}
                />
              ))}
            </div>
          )}
        </div>

        {/* Lessons panel */}
        <div className="flex-1">
          {selectedTopic && (
            <motion.div
              key={selectedTopic.id}
              initial={{ opacity: 0, x: 16 }}
              animate={{ opacity: 1, x: 0 }}
              transition={{ duration: 0.25 }}
            >
              <div className="flex items-center justify-between mb-4 flex-wrap gap-3">
                <div>
                  <h2 className="text-2xl font-bold text-white">
                    {selectedTopic.icon} {selectedTopic.title}
                  </h2>
                  <p className="text-quest-muted text-sm mt-0.5">{selectedTopic.description}</p>
                </div>
                <span className="text-sm text-quest-muted">
                  {selectedTopic.completed_lessons}/{selectedTopic.total_lessons} {t('road.lessons')}
                </span>
              </div>

              <ProgressBar
                value={selectedTopic.completed_lessons}
                max={selectedTopic.total_lessons || 1}
                color={selectedTopic.is_completed ? 'green' : 'purple'}
              />

              <div className="mt-6 space-y-3">
                {loadingLessons ? (
                  <ListSkeleton count={3} />
                ) : (
                  lessons.map((lesson, i) => {
                    const isAccessible =
                      !selectedTopic.is_locked && (i === 0 || lessons[i - 1]?.is_completed)

                    return (
                      <motion.div
                        key={lesson.id}
                        initial={{ opacity: 0, y: 8 }}
                        animate={{ opacity: 1, y: 0 }}
                        transition={{ delay: i * 0.05 }}
                        className={`card flex items-center gap-4 transition-all ${
                          lesson.is_completed
                            ? 'border-quest-green/30 bg-quest-green/5 shadow-[0_2px_8px_rgba(34,197,94,0.1)]'
                            : isAccessible
                            ? 'hover:border-quest-purple/50 cursor-pointer hover:shadow-[0_4px_16px_rgba(124,58,237,0.15)]'
                            : 'opacity-50 cursor-not-allowed'
                        }`}
                        onClick={() => isAccessible && handleStartLesson(lesson)}
                      >
                        <div className={`w-10 h-10 rounded-xl flex items-center justify-center flex-shrink-0 ${
                          lesson.is_completed ? 'bg-quest-green/20 text-xs' : 'bg-quest-border text-lg'
                        }`}>
                          {lesson.is_completed
                            ? (() => {
                                const lvl = lesson.mastery_level ?? 1
                                const filled = '⭐'.repeat(lvl)
                                const empty = '☆'.repeat(3 - lvl)
                                return <span className="leading-none">{filled}{empty}</span>
                              })()
                            : String(i + 1)}
                        </div>
                        <div className="flex-1 min-w-0">
                          <div className="font-semibold text-white truncate">{lesson.title}</div>
                          <div className="text-xs text-quest-muted mt-0.5 flex items-center flex-wrap gap-1">
                            {TYPE_LABELS[lesson.type]} • {lesson.xp_reward} XP
                            {(lesson as any).difficulty && (
                              <span className={`ml-1 text-xs px-1.5 py-0.5 rounded font-medium ${
                                (lesson as any).difficulty === 'easy'
                                  ? 'bg-quest-green/20 text-quest-green'
                                  : (lesson as any).difficulty === 'medium'
                                  ? 'bg-quest-yellow/20 text-quest-yellow'
                                  : 'bg-red-400/20 text-red-400'
                              }`}>
                                {(lesson as any).difficulty === 'easy' ? '🟢 Easy'
                                 : (lesson as any).difficulty === 'medium' ? '🟡 Medium'
                                 : '🔴 Hard'}
                              </span>
                            )}
                          </div>
                        </div>
                        {isAccessible && !lesson.is_completed && (
                          <ChevronRight className="w-5 h-5 text-quest-muted flex-shrink-0" />
                        )}
                        {lesson.is_completed && (
                          <span className="text-xs font-medium text-quest-green flex-shrink-0">
                            +{lesson.xp_earned} XP
                          </span>
                        )}
                      </motion.div>
                    )
                  })
                )}
              </div>
            </motion.div>
          )}
        </div>
      </div>
    </motion.div>
  )
}

import { useState } from 'react'
import { useQuery, useMutation, useQueryClient } from '@tanstack/react-query'
import { Route, ChevronDown, ChevronUp, RefreshCw, BookOpen, Code2, FlaskConical, RotateCcw, Mic, Bug, CheckCircle, Circle, Trophy, Briefcase, FolderOpen, Github, ExternalLink, Plus, Trash2 } from 'lucide-react'
import { motion } from 'framer-motion'
import { fetchTrainingPlan, adjustTrainingPlan, advancePhase, fetchPortfolioProjects, createPortfolioProject, deletePortfolioProject } from '../lib/api'
import { useT } from '../i18n/useT'
import type { PlanPhase, PlanActivity, PlanTopic } from '../types'

// ── Icons & colours ──────────────────────────────────────────────────────────

const ACT_ICON: Record<PlanActivity['type'], React.ReactNode> = {
  theory:        <BookOpen size={13} />,
  coding:        <Code2 size={13} />,
  project:       <FlaskConical size={13} />,
  review:        <RotateCcw size={13} />,
  interview_prep:<Mic size={13} />,
  debugging:     <Bug size={13} />,
}

const ACT_COLOR: Record<PlanActivity['type'], string> = {
  theory:        'text-violet-400 bg-violet-500/10',
  coding:        'text-blue-400 bg-blue-500/10',
  project:       'text-emerald-400 bg-emerald-500/10',
  review:        'text-amber-400 bg-amber-500/10',
  interview_prep:'text-rose-400 bg-rose-500/10',
  debugging:     'text-orange-400 bg-orange-500/10',
}

const DEPTH_COLOR: Record<string, string> = {
  understand: 'text-gray-400 bg-white/5',
  apply:      'text-blue-400 bg-blue-500/10',
  master:     'text-violet-400 bg-violet-500/10',
}

const RELEVANCE_COLOR: Record<string, string> = {
  low:    'text-gray-500',
  medium: 'text-amber-400',
  high:   'text-red-400',
}

const DAYS_ORDER = ['Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday']

// ── Sub-components ────────────────────────────────────────────────────────────

function TopicCard({ topic }: { topic: PlanTopic }) {
  const [open, setOpen] = useState(false)
  const t = useT()
  return (
    <div className="border border-white/10 rounded-xl">
      <button
        onClick={() => setOpen(!open)}
        className="w-full flex items-center justify-between p-3 text-left"
      >
        <div className="flex items-center gap-2 min-w-0">
          <span className="font-medium text-white text-sm truncate">{topic.name}</span>
          <span className={`text-xs px-1.5 py-0.5 rounded shrink-0 ${DEPTH_COLOR[topic.depth]}`}>
            {topic.depth}
          </span>
        </div>
        <div className="flex items-center gap-1.5 shrink-0 ml-2">
          <span className={`text-xs font-medium ${RELEVANCE_COLOR[topic.interview_relevance]}`}>
            {topic.interview_relevance === 'high' ? `🔥 ${t('path.high')}` : topic.interview_relevance === 'medium' ? `⚡ ${t('path.med')}` : `− ${t('path.low')}`} {t('path.interview')}
          </span>
          {open ? <ChevronUp size={14} className="text-gray-500" /> : <ChevronDown size={14} className="text-gray-500" />}
        </div>
      </button>
      {open && (
        <div className="px-3 pb-3 space-y-2">
          <div className="flex flex-wrap gap-1.5">
            {topic.subtopics.map((s) => (
              <span key={s} className="text-xs bg-white/5 text-gray-300 px-2 py-0.5 rounded">{s}</span>
            ))}
          </div>
          <p className="text-xs text-gray-400 italic">{topic.why_important}</p>
        </div>
      )}
    </div>
  )
}

function DayCard({ day, isToday }: { day: { day: string; duration_minutes: number; activities: PlanActivity[] }; isToday: boolean }) {
  const [open, setOpen] = useState(isToday)
  const t = useT()
  const must = day.activities.filter((a) => a.priority === 'must')
  const optional = day.activities.filter((a) => a.priority === 'optional')

  return (
    <div className={`rounded-xl border transition-all ${isToday ? 'border-violet-500/60 bg-violet-500/5' : 'border-white/10 bg-quest-card'}`}>
      <button onClick={() => setOpen(!open)} className="w-full flex items-center justify-between p-4 text-left">
        <div className="flex items-center gap-3">
          {isToday && <span className="text-xs font-bold text-violet-400 bg-violet-500/20 px-2 py-0.5 rounded-full">{t('path.today')}</span>}
          <span className="font-semibold text-white">{day.day}</span>
          <span className="text-sm text-gray-500">{day.duration_minutes} min</span>
        </div>
        <div className="flex items-center gap-1.5 text-gray-400">
          <span className="text-sm">{day.activities.length} {t('path.tasks')}</span>
          {open ? <ChevronUp size={15} /> : <ChevronDown size={15} />}
        </div>
      </button>
      {open && (
        <div className="px-4 pb-4 space-y-2">
          {must.map((act, i) => (
            <div key={i} className="flex items-start gap-3 p-3 rounded-lg bg-white/5">
              <span className={`mt-0.5 p-1 rounded shrink-0 ${ACT_COLOR[act.type]}`}>{ACT_ICON[act.type]}</span>
              <div className="flex-1 min-w-0">
                <div className="text-sm font-medium text-white">{act.title}</div>
                <div className="text-xs text-gray-400 mt-0.5">{act.description}</div>
                {act.resource && <div className="text-xs text-violet-400/70 mt-1">📚 {act.resource}</div>}
              </div>
              <span className="text-xs text-violet-400 shrink-0 mt-0.5">{t('path.must')}</span>
            </div>
          ))}
          {optional.map((act, i) => (
            <div key={i} className="flex items-start gap-3 p-3 rounded-lg bg-white/[0.03] opacity-65">
              <span className={`mt-0.5 p-1 rounded shrink-0 ${ACT_COLOR[act.type]}`}>{ACT_ICON[act.type]}</span>
              <div className="flex-1 min-w-0">
                <div className="text-sm font-medium text-white/80">{act.title}</div>
                <div className="text-xs text-gray-500 mt-0.5">{act.description}</div>
              </div>
              <span className="text-xs text-gray-500 shrink-0 mt-0.5">{t('path.optional')}</span>
            </div>
          ))}
        </div>
      )}
    </div>
  )
}

function PhaseTab({ phase, isCurrent, onClick }: { phase: PlanPhase; isCurrent: boolean; onClick: () => void }) {
  return (
    <button
      onClick={onClick}
      className={`flex-1 py-2.5 px-3 text-sm font-medium rounded-lg transition-all whitespace-nowrap
        ${isCurrent ? 'bg-violet-600 text-white' : 'text-gray-400 hover:text-white hover:bg-white/5'}`}
    >
      <span className="hidden sm:inline">Phase {phase.phase_number} — </span>
      <span className="line-clamp-1">{phase.title.replace(/Phase \d+ — /, '')}</span>
    </button>
  )
}

// ── Main page ─────────────────────────────────────────────────────────────────

export default function MyPath() {
  const qc = useQueryClient()
  const t = useT()
  const [viewPhase, setViewPhase] = useState<number | null>(null)
  const [adjustNotes, setAdjustNotes] = useState('')
  const [showAdjust, setShowAdjust] = useState(false)
  const [showPortfolio, setShowPortfolio] = useState(false)

  const { data, isLoading } = useQuery({
    queryKey: ['training-plan'],
    queryFn: fetchTrainingPlan,
  })

  const { data: projects = [] } = useQuery({
    queryKey: ['portfolio-projects'],
    queryFn: fetchPortfolioProjects,
  })

  const [showProjectForm, setShowProjectForm] = useState(false)
  const [newProject, setNewProject] = useState({ title: '', description: '', github_url: '', live_url: '' })

  const { mutate: addProject, isPending: addingProject } = useMutation({
    mutationFn: createPortfolioProject,
    onSuccess: () => {
      qc.invalidateQueries({ queryKey: ['portfolio-projects'] })
      setShowProjectForm(false)
      setNewProject({ title: '', description: '', github_url: '', live_url: '' })
    },
  })

  const { mutate: removeProject } = useMutation({
    mutationFn: deletePortfolioProject,
    onSuccess: () => qc.invalidateQueries({ queryKey: ['portfolio-projects'] }),
  })

  const adjustMutation = useMutation({
    mutationFn: () => adjustTrainingPlan(adjustNotes),
    onSuccess: () => {
      qc.invalidateQueries({ queryKey: ['training-plan'] })
      setShowAdjust(false)
      setAdjustNotes('')
    },
  })

  const advanceMutation = useMutation({
    mutationFn: (phase: number) => advancePhase(phase),
    onSuccess: () => qc.invalidateQueries({ queryKey: ['training-plan'] }),
  })

  if (isLoading) {
    return (
      <div className="flex items-center justify-center min-h-[60vh]">
        <div className="text-gray-400">{t('path.loading')}</div>
      </div>
    )
  }

  if (!data?.plan) {
    return (
      <div className="max-w-2xl mx-auto px-4 py-16 text-center">
        <Route size={48} className="mx-auto text-gray-600 mb-4" />
        <h2 className="text-xl font-semibold text-white mb-2">{t('path.noPlan')}</h2>
        <p className="text-gray-400 mb-6">{t('path.noPlanDesc')}</p>
        <a href="/onboarding" className="inline-block px-6 py-3 bg-violet-600 hover:bg-violet-500 text-white font-semibold rounded-xl transition-colors">
          {t('path.startOnboarding')}
        </a>
      </div>
    )
  }

  const { plan, meta } = data

  // Handle legacy single-phase plans (from before the update)
  if (!plan.phases) {
    return (
      <div className="max-w-2xl mx-auto px-4 py-16 text-center">
        <Route size={48} className="mx-auto text-gray-600 mb-4" />
        <h2 className="text-xl font-semibold text-white mb-2">{t('path.planOutdated')}</h2>
        <p className="text-gray-400 mb-6">{t('path.planOutdatedDesc')}</p>
        <a href="/onboarding" className="inline-block px-6 py-3 bg-violet-600 hover:bg-violet-500 text-white font-semibold rounded-xl transition-colors">
          {t('path.regeneratePlan')}
        </a>
      </div>
    )
  }

  const currentPhaseNum = meta?.current_phase ?? 1
  const activePhaseIdx = viewPhase !== null ? viewPhase - 1 : currentPhaseNum - 1
  const phase = plan.phases[Math.min(activePhaseIdx, plan.phases.length - 1)]
  const today = new Date().toLocaleDateString('en-US', { weekday: 'long' })
  const isCurrentPhase = (viewPhase ?? currentPhaseNum) === currentPhaseNum

  const orderedDays = [...(phase.weekly_schedule ?? [])].sort(
    (a, b) => DAYS_ORDER.indexOf(a.day) - DAYS_ORDER.indexOf(b.day),
  )

  const companyKey = meta?.company_target?.includes('Startup') ? 'startup'
    : meta?.company_target?.includes('Large') ? 'large_company'
    : 'medium_company'
  const interviewSection = plan.interview_preparation?.[companyKey]

  return (
    <div className="max-w-4xl mx-auto px-4 py-8">
      {/* Header */}
      <div className="mb-6">
        <div className="flex items-center gap-2 text-violet-400 text-sm font-medium mb-2">
          <Route size={15} />
          {t('path.title')}
        </div>
        <div className="flex items-start justify-between gap-4">
          <div>
            <h1 className="text-2xl font-bold text-white">{phase.title}</h1>
            <p className="text-gray-400 mt-1">{phase.goal}</p>
          </div>
          <div className="text-right shrink-0">
            <div className="text-2xl font-bold text-white">{phase.duration_weeks}w</div>
            <div className="text-xs text-gray-500">{t('path.duration')}</div>
          </div>
        </div>
      </div>

      {/* Phase tabs */}
      <div className="flex gap-1.5 bg-white/5 p-1.5 rounded-xl mb-6 overflow-x-auto">
        {plan.phases.map((p) => (
          <PhaseTab
            key={p.phase_number}
            phase={p}
            isCurrent={(viewPhase ?? currentPhaseNum) === p.phase_number}
            onClick={() => setViewPhase(p.phase_number)}
          />
        ))}
      </div>

      {/* Meta chips */}
      {meta && (
        <div className="flex flex-wrap gap-2 mb-6">
          {[
            meta.company_target && { label: t('path.target'), value: meta.company_target },
            meta.framework_focus && { label: t('path.focus'), value: meta.framework_focus },
            { label: t('path.language'), value: meta.language },
          ].filter(Boolean).map((m) => m && (
            <div key={m.label} className="bg-white/5 border border-white/10 rounded-lg px-3 py-1.5 text-sm">
              <span className="text-gray-500">{m.label}: </span>
              <span className="text-white capitalize">{m.value}</span>
            </div>
          ))}
        </div>
      )}

      <div className="grid grid-cols-1 lg:grid-cols-3 gap-6">
        {/* Left column: topics + schedule */}
        <div className="lg:col-span-2 space-y-6">
          {/* Topics */}
          <div>
            <h2 className="text-sm font-semibold text-gray-400 uppercase tracking-wide mb-3">{t('path.topicsThisPhase')}</h2>
            <div className="space-y-2">
              {phase.topics.map((topic) => (
                <TopicCard key={topic.name} topic={topic} />
              ))}
            </div>
          </div>

          {/* Weekly schedule */}
          <div>
            <h2 className="text-sm font-semibold text-gray-400 uppercase tracking-wide mb-3">{t('path.weeklySchedule')}</h2>
            <div className="space-y-2">
              {orderedDays.map((day) => (
                <DayCard key={day.day} day={day} isToday={isCurrentPhase && day.day === today} />
              ))}
            </div>
          </div>
        </div>

        {/* Right column: milestone + phase complete + interview prep */}
        <div className="space-y-5">
          {/* Milestone */}
          <div className="bg-amber-500/10 border border-amber-500/30 rounded-xl p-4">
            <div className="flex items-center gap-2 text-amber-400 text-xs font-semibold uppercase tracking-wide mb-2">
              <Trophy size={13} />
              {t('path.phaseMilestone')}
            </div>
            <div className="font-semibold text-white text-sm mb-1">{phase.milestone_project.title}</div>
            <p className="text-xs text-gray-400 mb-3">{phase.milestone_project.description}</p>
            <div className="flex flex-wrap gap-1">
              {phase.milestone_project.skills_practiced.map((s) => (
                <span key={s} className="text-xs bg-amber-500/10 text-amber-300 px-2 py-0.5 rounded">{s}</span>
              ))}
            </div>
          </div>

          {/* Phase complete when */}
          <div className="bg-quest-card border border-white/10 rounded-xl p-4">
            <div className="text-xs font-semibold text-gray-400 uppercase tracking-wide mb-3">{t('path.phaseCompleteWhen')}</div>
            <ul className="space-y-2">
              {phase.phase_complete_when.map((c, i) => (
                <li key={i} className="flex items-start gap-2 text-xs text-gray-300">
                  <CheckCircle size={13} className="text-emerald-400 mt-0.5 shrink-0" />
                  {c}
                </li>
              ))}
            </ul>
            {isCurrentPhase && currentPhaseNum < plan.phases.length && (
              <button
                onClick={() => advanceMutation.mutate(currentPhaseNum + 1)}
                disabled={advanceMutation.isPending}
                className="mt-4 w-full py-2 text-sm font-medium bg-emerald-600/20 border border-emerald-500/30
                           text-emerald-400 hover:bg-emerald-600/30 rounded-lg transition-colors disabled:opacity-40"
              >
                {t('path.phaseCompleteWhen')} {currentPhaseNum} →
              </button>
            )}
          </div>

          {/* Interview prep for target company */}
          {interviewSection && (
            <div className="bg-quest-card border border-white/10 rounded-xl p-4">
              <div className="flex items-center gap-2 text-xs font-semibold text-gray-400 uppercase tracking-wide mb-3">
                <Briefcase size={12} />
                {t('path.interviewPrep')} — {meta?.company_target?.split('/')[0].trim()}
              </div>
              <div className="space-y-3">
                <div>
                  <div className="text-xs text-gray-500 mb-1.5">{t('path.typicalQuestions')}</div>
                  <ul className="space-y-1">
                    {interviewSection.typical_questions.slice(0, 3).map((q, i) => (
                      <li key={i} className="text-xs text-gray-300 flex items-start gap-1.5">
                        <span className="text-violet-400 mt-0.5 shrink-0">•</span>
                        {q}
                      </li>
                    ))}
                  </ul>
                </div>
                <div>
                  <div className="text-xs text-gray-500 mb-1.5">{t('path.codingChallenges')}</div>
                  <ul className="space-y-1">
                    {interviewSection.coding_challenges.slice(0, 2).map((c, i) => (
                      <li key={i} className="text-xs text-gray-300 flex items-start gap-1.5">
                        <span className="text-blue-400 mt-0.5 shrink-0">▸</span>
                        {c}
                      </li>
                    ))}
                  </ul>
                </div>
              </div>
            </div>
          )}

          {/* Portfolio requirements */}
          {plan.portfolio_requirements && (
            <div className="bg-quest-card border border-white/10 rounded-xl p-4">
              <button
                onClick={() => setShowPortfolio(!showPortfolio)}
                className="flex items-center justify-between w-full"
              >
                <div className="text-xs font-semibold text-gray-400 uppercase tracking-wide">
                  {t('path.portfolioReqs')}
                </div>
                {showPortfolio ? <ChevronUp size={13} className="text-gray-500" /> : <ChevronDown size={13} className="text-gray-500" />}
              </button>
              {showPortfolio && (
                <div className="mt-3 space-y-3">
                  <div>
                    <div className="text-xs text-gray-500 mb-1.5">{t('path.mustHave')}</div>
                    <ul className="space-y-1">
                      {plan.portfolio_requirements.must_have_features.map((f, i) => (
                        <li key={i} className="text-xs text-gray-300 flex items-start gap-1.5">
                          <Circle size={10} className="text-violet-400 mt-0.5 shrink-0" />
                          {f}
                        </li>
                      ))}
                    </ul>
                  </div>
                  <div>
                    <div className="text-xs text-gray-500 mb-1.5">{t('path.niceToHave')}</div>
                    <ul className="space-y-1">
                      {plan.portfolio_requirements.nice_to_have.map((f, i) => (
                        <li key={i} className="text-xs text-gray-400 flex items-start gap-1.5">
                          <span className="text-gray-600 mt-0.5 shrink-0">○</span>
                          {f}
                        </li>
                      ))}
                    </ul>
                  </div>
                </div>
              )}
            </div>
          )}
        </div>
      </div>

      {/* Portfolio Tracker */}
      <div className="card mt-6">
        <div className="flex items-center justify-between mb-4">
          <div className="flex items-center gap-2">
            <FolderOpen className="w-5 h-5 text-quest-purple" />
            <h3 className="font-bold text-white text-lg">{t('path.myPortfolio')}</h3>
          </div>
          <button
            onClick={() => setShowProjectForm(v => !v)}
            className="btn-secondary flex items-center gap-1 text-sm py-1.5 px-3"
          >
            <Plus className="w-4 h-4" />
            {t('path.addProject')}
          </button>
        </div>

        {showProjectForm && (
          <motion.div
            initial={{ opacity: 0, height: 0 }}
            animate={{ opacity: 1, height: 'auto' }}
            className="mb-4 p-4 bg-quest-border/20 rounded-xl space-y-3"
          >
            <input
              type="text"
              placeholder="Project title *"
              value={newProject.title}
              onChange={e => setNewProject(v => ({ ...v, title: e.target.value }))}
              className="w-full bg-quest-bg border border-quest-border rounded-xl px-3 py-2 text-sm text-white placeholder-quest-muted focus:outline-none focus:border-quest-purple"
            />
            <input
              type="text"
              placeholder="Short description"
              value={newProject.description}
              onChange={e => setNewProject(v => ({ ...v, description: e.target.value }))}
              className="w-full bg-quest-bg border border-quest-border rounded-xl px-3 py-2 text-sm text-white placeholder-quest-muted focus:outline-none focus:border-quest-purple"
            />
            <div className="flex gap-2">
              <input
                type="text"
                placeholder="GitHub URL"
                value={newProject.github_url}
                onChange={e => setNewProject(v => ({ ...v, github_url: e.target.value }))}
                className="flex-1 bg-quest-bg border border-quest-border rounded-xl px-3 py-2 text-sm text-white placeholder-quest-muted focus:outline-none focus:border-quest-purple"
              />
              <input
                type="text"
                placeholder="Live URL"
                value={newProject.live_url}
                onChange={e => setNewProject(v => ({ ...v, live_url: e.target.value }))}
                className="flex-1 bg-quest-bg border border-quest-border rounded-xl px-3 py-2 text-sm text-white placeholder-quest-muted focus:outline-none focus:border-quest-purple"
              />
            </div>
            <div className="flex gap-2">
              <button
                disabled={!newProject.title || addingProject}
                onClick={() => addProject({ ...newProject })}
                className="btn-primary text-sm py-1.5 px-4"
              >
                {addingProject ? t('path.adding') : t('path.add')}
              </button>
              <button onClick={() => setShowProjectForm(false)} className="btn-secondary text-sm py-1.5 px-4">
                {t('path.cancel')}
              </button>
            </div>
          </motion.div>
        )}

        {projects.length === 0 ? (
          <p className="text-quest-muted text-sm text-center py-4">
            {t('path.noProjects')}
          </p>
        ) : (
          <div className="space-y-3">
            {projects.map(p => (
              <div key={p.id} className="flex items-start gap-3 p-3 rounded-xl bg-quest-border/10 border border-quest-border">
                <FolderOpen className="w-5 h-5 text-quest-purple flex-shrink-0 mt-0.5" />
                <div className="flex-1 min-w-0">
                  <p className="font-semibold text-white text-sm">{p.title}</p>
                  {p.description && <p className="text-xs text-quest-muted mt-0.5">{p.description}</p>}
                  <div className="flex gap-3 mt-1.5">
                    {p.github_url && (
                      <a href={p.github_url} target="_blank" rel="noreferrer"
                        className="flex items-center gap-1 text-xs text-quest-muted hover:text-white transition-colors">
                        <Github className="w-3 h-3" /> GitHub
                      </a>
                    )}
                    {p.live_url && (
                      <a href={p.live_url} target="_blank" rel="noreferrer"
                        className="flex items-center gap-1 text-xs text-quest-muted hover:text-white transition-colors">
                        <ExternalLink className="w-3 h-3" /> Live
                      </a>
                    )}
                  </div>
                </div>
                <button
                  onClick={() => removeProject(p.id)}
                  className="text-quest-muted hover:text-red-400 transition-colors p-1"
                >
                  <Trash2 className="w-4 h-4" />
                </button>
              </div>
            ))}
          </div>
        )}
      </div>

      {/* Adjust plan */}
      <div className="mt-8 border border-white/10 rounded-xl p-5">
        <div className="flex items-center justify-between mb-3">
          <h2 className="text-sm font-semibold text-gray-400 uppercase tracking-wide">{t('path.adjustPlan')}</h2>
          <button
            onClick={() => setShowAdjust(!showAdjust)}
            className="text-sm text-violet-400 hover:text-violet-300 flex items-center gap-1"
          >
            <RefreshCw size={13} />
            {t('path.regenerate')}
          </button>
        </div>
        {showAdjust && (
          <div className="space-y-3">
            <textarea
              value={adjustNotes}
              onChange={(e) => setAdjustNotes(e.target.value)}
              placeholder="E.g. 'I'm struggling with closures, add more practice' or 'I'm ahead of schedule, make it harder'"
              rows={3}
              className="w-full bg-white/5 border border-white/10 rounded-lg px-3 py-2 text-white text-sm
                         placeholder-gray-500 resize-none focus:outline-none focus:border-violet-500/50"
            />
            <div className="flex gap-2">
              <button
                onClick={() => adjustMutation.mutate()}
                disabled={!adjustNotes.trim() || adjustMutation.isPending}
                className="px-4 py-2 bg-violet-600 hover:bg-violet-500 disabled:opacity-40 text-white text-sm font-medium rounded-lg transition-colors"
              >
                {adjustMutation.isPending ? t('path.regenerating') : t('path.regeneratePlan')}
              </button>
              <button onClick={() => setShowAdjust(false)} className="px-4 py-2 text-gray-400 hover:text-white text-sm transition-colors">
                {t('path.cancel')}
              </button>
            </div>
          </div>
        )}
      </div>
    </div>
  )
}

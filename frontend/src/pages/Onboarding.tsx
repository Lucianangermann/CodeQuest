import { useState } from 'react'
import { useNavigate } from 'react-router-dom'
import { useMutation } from '@tanstack/react-query'
import { useUserStore } from '../store/useUserStore'
import { completeOnboarding } from '../lib/api'
import type {
  OnboardingGoal, OnboardingTimeline, OnboardingLevel,
  OnboardingLanguage, OnboardingCompany, OnboardingFocus,
} from '../types'

// ── Data ──────────────────────────────────────────────────────────────────────

const GOALS = [
  { value: 'job'     as OnboardingGoal, label: 'Get a Dev Job',   icon: '💼', desc: 'Land my first developer role' },
  { value: 'hobby'   as OnboardingGoal, label: 'Hobby / Fun',     icon: '🎮', desc: 'Build cool things for fun' },
  { value: 'school'  as OnboardingGoal, label: 'School / Course', icon: '🎓', desc: 'Supplement my studies' },
  { value: 'upskill' as OnboardingGoal, label: 'Upskill at Work', icon: '📈', desc: 'Level up in my current role' },
]

const TIMELINES = [
  { value: '1month'  as OnboardingTimeline, label: '1 Month',   desc: 'Intensive, daily commitment' },
  { value: '3months' as OnboardingTimeline, label: '3 Months',  desc: 'Steady and consistent pace' },
  { value: '6months' as OnboardingTimeline, label: '6 Months',  desc: 'Relaxed, a few hours/week' },
  { value: 'no_rush' as OnboardingTimeline, label: 'No Rush',   desc: 'At my own pace' },
]

const COMPANIES = [
  { value: 'startup' as OnboardingCompany, label: 'Startup / Small',   icon: '🚀', desc: '< 50 employees — fast-paced, wear many hats' },
  { value: 'medium'  as OnboardingCompany, label: 'Medium Company',    icon: '🏢', desc: '50–500 employees — process, quality focus' },
  { value: 'large'   as OnboardingCompany, label: 'Large Corporation', icon: '🏦', desc: '500+ employees — structured interviews, DS&A' },
]

const LEVELS = [
  { value: 'absolute_beginner' as OnboardingLevel, label: 'Total Beginner',  desc: 'Never written code before' },
  { value: 'some_basics'       as OnboardingLevel, label: 'Some Basics',     desc: 'I know variables and loops' },
  { value: 'intermediate'      as OnboardingLevel, label: 'Intermediate',    desc: 'I can build small projects' },
]

const LANGUAGES = [
  { value: 'javascript' as OnboardingLanguage, label: 'JavaScript', icon: '🟨' },
  { value: 'typescript' as OnboardingLanguage, label: 'TypeScript', icon: '🔷' },
  { value: 'python'     as OnboardingLanguage, label: 'Python',     icon: '🐍' },
]

const FOCUSES = [
  { value: 'frontend'  as OnboardingFocus, label: 'Frontend',  icon: '🎨', desc: 'React, UI, CSS, user interfaces' },
  { value: 'backend'   as OnboardingFocus, label: 'Backend',   icon: '⚙️', desc: 'APIs, Databases, Server logic' },
  { value: 'fullstack' as OnboardingFocus, label: 'Fullstack', icon: '🔄', desc: 'Both — ship entire features alone' },
]

// ── Label maps (what Claude receives) ────────────────────────────────────────

const GOAL_LABEL: Record<OnboardingGoal, string> = {
  job: 'Get a Junior Developer Job', hobby: 'Build Fun Hobby Projects',
  school: 'Succeed in School / Course', upskill: 'Upskill at Work',
}
const TIMELINE_LABEL: Record<OnboardingTimeline, string> = {
  '1month': '1 month', '3months': '3 months', '6months': '6 months', no_rush: 'no rush',
}
const LEVEL_LABEL: Record<OnboardingLevel, string> = {
  absolute_beginner: 'Absolute Beginner', some_basics: 'Some Basics', intermediate: 'Intermediate',
}
const COMPANY_LABEL: Record<OnboardingCompany, string> = {
  startup: 'Startup / Small Company (< 50 employees)',
  medium: 'Medium Company (50–500 employees)',
  large: 'Large Corporation (500+ employees)',
}
const FOCUS_LABEL: Record<OnboardingFocus, string> = {
  frontend: 'Frontend (React, UI, CSS)', backend: 'Backend (APIs, Databases, Server)', fullstack: 'Fullstack (Frontend + Backend)',
}

// ── Choice card ───────────────────────────────────────────────────────────────

function ChoiceCard({
  selected, onClick, children,
}: { selected: boolean; onClick: () => void; children: React.ReactNode }) {
  return (
    <button
      onClick={onClick}
      className={`w-full p-4 rounded-xl border-2 text-left transition-all
        ${selected ? 'border-violet-500 bg-violet-500/10' : 'border-white/10 bg-white/5 hover:border-violet-400/50'}`}
    >
      {children}
    </button>
  )
}

// ── Component ─────────────────────────────────────────────────────────────────

export default function Onboarding() {
  const navigate = useNavigate()
  const setUser = useUserStore((s) => s.setUser)
  const user = useUserStore((s) => s.user)

  const [step, setStep]         = useState(0)
  const [goal, setGoal]         = useState<OnboardingGoal | null>(null)
  const [timeline, setTimeline] = useState<OnboardingTimeline | null>(null)
  const [company, setCompany]   = useState<OnboardingCompany | null>(null)
  const [level, setLevel]       = useState<OnboardingLevel | null>(null)
  const [language, setLanguage] = useState<OnboardingLanguage | null>(null)
  const [focus, setFocus]       = useState<OnboardingFocus | null>(null)

  const TOTAL_STEPS = 6

  const mutation = useMutation({
    mutationFn: () =>
      completeOnboarding({
        goal:           GOAL_LABEL[goal!],
        timeline:       TIMELINE_LABEL[timeline!],
        level:          LEVEL_LABEL[level!],
        language:       language!,
        company_target: COMPANY_LABEL[company!],
        framework_focus: FOCUS_LABEL[focus!],
      }),
    onSuccess: () => {
      if (user) setUser({ ...user, onboarding_completed: true })
      navigate('/my-path')
    },
  })

  const steps = [
    {
      title: "What's your goal?",
      subtitle: "We'll tailor your learning path to what matters most.",
      content: (
        <div className="space-y-3">
          {GOALS.map((g) => (
            <ChoiceCard key={g.value} selected={goal === g.value} onClick={() => { setGoal(g.value); setStep(1) }}>
              <div className="flex items-center gap-4">
                <span className="text-3xl">{g.icon}</span>
                <div>
                  <div className="font-semibold text-white">{g.label}</div>
                  <div className="text-sm text-gray-400">{g.desc}</div>
                </div>
              </div>
            </ChoiceCard>
          ))}
        </div>
      ),
    },
    {
      title: "What's your timeline?",
      subtitle: "Be realistic — consistency beats intensity.",
      content: (
        <div className="grid grid-cols-2 gap-3">
          {TIMELINES.map((t) => (
            <ChoiceCard key={t.value} selected={timeline === t.value} onClick={() => { setTimeline(t.value); setStep(2) }}>
              <div className="font-semibold text-white">{t.label}</div>
              <div className="text-sm text-gray-400 mt-1">{t.desc}</div>
            </ChoiceCard>
          ))}
        </div>
      ),
    },
    {
      title: "What kind of company are you targeting?",
      subtitle: "This shapes the interview questions and depth of your plan.",
      content: (
        <div className="space-y-3">
          {COMPANIES.map((c) => (
            <ChoiceCard key={c.value} selected={company === c.value} onClick={() => { setCompany(c.value); setStep(3) }}>
              <div className="flex items-center gap-4">
                <span className="text-3xl">{c.icon}</span>
                <div>
                  <div className="font-semibold text-white">{c.label}</div>
                  <div className="text-sm text-gray-400">{c.desc}</div>
                </div>
              </div>
            </ChoiceCard>
          ))}
        </div>
      ),
    },
    {
      title: "What's your current level?",
      subtitle: "No pressure — we all start somewhere.",
      content: (
        <div className="space-y-3">
          {LEVELS.map((l) => (
            <ChoiceCard key={l.value} selected={level === l.value} onClick={() => { setLevel(l.value); setStep(4) }}>
              <div className="font-semibold text-white">{l.label}</div>
              <div className="text-sm text-gray-400 mt-1">{l.desc}</div>
            </ChoiceCard>
          ))}
        </div>
      ),
    },
    {
      title: "Pick your primary language",
      subtitle: "You'll learn others along the way.",
      content: (
        <div className="grid grid-cols-3 gap-3">
          {LANGUAGES.map((lang) => (
            <ChoiceCard key={lang.value} selected={language === lang.value} onClick={() => { setLanguage(lang.value); setStep(5) }}>
              <div className="flex flex-col items-center gap-2 py-2">
                <span className="text-3xl">{lang.icon}</span>
                <span className="font-medium text-white text-sm">{lang.label}</span>
              </div>
            </ChoiceCard>
          ))}
        </div>
      ),
    },
    {
      title: "Which area interests you most?",
      subtitle: "Your plan will emphasize this, but cover the full stack.",
      content: (
        <div className="space-y-3">
          {FOCUSES.map((f) => (
            <ChoiceCard key={f.value} selected={focus === f.value} onClick={() => setFocus(f.value)}>
              <div className="flex items-center gap-4">
                <span className="text-3xl">{f.icon}</span>
                <div>
                  <div className="font-semibold text-white">{f.label}</div>
                  <div className="text-sm text-gray-400">{f.desc}</div>
                </div>
              </div>
            </ChoiceCard>
          ))}
        </div>
      ),
    },
  ]

  return (
    <div className="min-h-screen bg-quest-bg flex items-center justify-center px-4 py-10">
      <div className="w-full max-w-lg">
        {/* Progress bar */}
        <div className="flex items-center gap-1.5 mb-8 justify-center">
          {steps.map((_, i) => (
            <div
              key={i}
              className={`h-1.5 rounded-full transition-all ${
                i === step ? 'w-10 bg-violet-500' : i < step ? 'w-4 bg-violet-400' : 'w-4 bg-white/15'
              }`}
            />
          ))}
        </div>

        <div className="bg-quest-card border border-white/10 rounded-2xl p-8">
          <div className="mb-6">
            <div className="text-xs font-semibold text-violet-400 uppercase tracking-wide mb-1">
              Step {step + 1} of {TOTAL_STEPS}
            </div>
            <h1 className="text-2xl font-bold text-white mb-1">{steps[step].title}</h1>
            <p className="text-gray-400">{steps[step].subtitle}</p>
          </div>

          {steps[step].content}

          {/* Submit button on last step */}
          {step === TOTAL_STEPS - 1 && (
            <button
              onClick={() => mutation.mutate()}
              disabled={!focus || mutation.isPending}
              className="mt-6 w-full py-3.5 bg-violet-600 hover:bg-violet-500 disabled:opacity-40
                         text-white font-semibold rounded-xl transition-colors text-base"
            >
              {mutation.isPending
                ? '✨ Building your personalized plan with AI...'
                : 'Generate My Learning Path →'}
            </button>
          )}

          {mutation.isError && (
            <p className="mt-3 text-red-400 text-sm text-center">
              Something went wrong generating the plan. Please try again.
            </p>
          )}

          {step > 0 && (
            <button
              onClick={() => setStep(step - 1)}
              className="mt-4 w-full py-2 text-gray-500 hover:text-white text-sm transition-colors"
            >
              ← Back
            </button>
          )}
        </div>
      </div>
    </div>
  )
}

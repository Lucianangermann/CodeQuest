import { useState, useEffect } from 'react'
import { useNavigate } from 'react-router-dom'
import { useMutation } from '@tanstack/react-query'
import { useUserStore } from '../store/useUserStore'
import { completeOnboarding } from '../lib/api'
import { useT } from '../i18n/useT'
import type {
  OnboardingGoal, OnboardingTimeline, OnboardingLevel,
  OnboardingLanguage, OnboardingCompany, OnboardingFocus,
} from '../types'

// ── Data ──────────────────────────────────────────────────────────────────────

const LANGUAGES = [
  { value: 'javascript' as OnboardingLanguage, label: 'JavaScript', icon: '🟨' },
  { value: 'typescript' as OnboardingLanguage, label: 'TypeScript', icon: '🔷' },
  { value: 'python'     as OnboardingLanguage, label: 'Python',     icon: '🐍' },
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
  const t = useT()

  const GOALS = [
    { value: 'job'     as OnboardingGoal, label: t('ob.goalJob'),     icon: '💼', desc: t('ob.goalJobDesc') },
    { value: 'hobby'   as OnboardingGoal, label: t('ob.goalHobby'),   icon: '🎮', desc: t('ob.goalHobbyDesc') },
    { value: 'school'  as OnboardingGoal, label: t('ob.goalSchool'),  icon: '🎓', desc: t('ob.goalSchoolDesc') },
    { value: 'upskill' as OnboardingGoal, label: t('ob.goalUpskill'), icon: '📈', desc: t('ob.goalUpskillDesc') },
  ]

  const TIMELINES = [
    { value: '1month'  as OnboardingTimeline, label: t('ob.tl1month'),   desc: t('ob.tl1monthDesc') },
    { value: '3months' as OnboardingTimeline, label: t('ob.tl3months'),  desc: t('ob.tl3monthsDesc') },
    { value: '6months' as OnboardingTimeline, label: t('ob.tl6months'),  desc: t('ob.tl6monthsDesc') },
    { value: 'no_rush' as OnboardingTimeline, label: t('ob.tlNoRush'),   desc: t('ob.tlNoRushDesc') },
  ]

  const COMPANIES = [
    { value: 'startup' as OnboardingCompany, label: t('ob.coStartup'), icon: '🚀', desc: t('ob.coStartupDesc') },
    { value: 'medium'  as OnboardingCompany, label: t('ob.coMedium'),  icon: '🏢', desc: t('ob.coMediumDesc') },
    { value: 'large'   as OnboardingCompany, label: t('ob.coLarge'),   icon: '🏦', desc: t('ob.coLargeDesc') },
  ]

  const LEVELS = [
    { value: 'absolute_beginner' as OnboardingLevel, label: t('ob.lvlBeginner'),    desc: t('ob.lvlBeginnerDesc') },
    { value: 'some_basics'       as OnboardingLevel, label: t('ob.lvlBasics'),      desc: t('ob.lvlBasicsDesc') },
    { value: 'intermediate'      as OnboardingLevel, label: t('ob.lvlIntermediate'), desc: t('ob.lvlIntermediateDesc') },
  ]

  const FOCUSES = [
    { value: 'frontend'  as OnboardingFocus, label: t('ob.focusFrontend'),  icon: '🎨', desc: t('ob.focusFrontendDesc') },
    { value: 'backend'   as OnboardingFocus, label: t('ob.focusBackend'),   icon: '⚙️', desc: t('ob.focusBackendDesc') },
    { value: 'fullstack' as OnboardingFocus, label: t('ob.focusFullstack'), icon: '🔄', desc: t('ob.focusFullstackDesc') },
  ]

  const [step, setStep]         = useState(0)
  const [goal, setGoal]         = useState<OnboardingGoal | null>(null)
  const [timeline, setTimeline] = useState<OnboardingTimeline | null>(null)
  const [company, setCompany]   = useState<OnboardingCompany | null>(null)
  const [level, setLevel]       = useState<OnboardingLevel | null>(null)
  const [language, setLanguage] = useState<OnboardingLanguage | null>(null)
  const [focus, setFocus]       = useState<OnboardingFocus | null>(null)

  const TOTAL_STEPS = 6

  const [buildStep, setBuildStep] = useState(0)
  const BUILD_STEPS = [
    t('ob.build0'),
    t('ob.build1'),
    t('ob.build2'),
    t('ob.build3'),
    t('ob.build4'),
  ]

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
      setBuildStep(BUILD_STEPS.length - 1)
      setTimeout(() => {
        if (user) setUser({ ...user, onboarding_completed: true, language_preference: language! })
        navigate('/my-path')
      }, 600)
    },
  })

  useEffect(() => {
    if (!mutation.isPending) return
    setBuildStep(0)
    const timings = [400, 900, 1400, 1900]
    const timers = timings.map((t, i) => setTimeout(() => setBuildStep(i + 1), t))
    return () => timers.forEach(clearTimeout)
  }, [mutation.isPending])

  const steps = [
    {
      title: t('ob.step0title'),
      subtitle: t('ob.step0sub'),
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
      title: t('ob.step1title'),
      subtitle: t('ob.step1sub'),
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
      title: t('ob.step2title'),
      subtitle: t('ob.step2sub'),
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
      title: t('ob.step3title'),
      subtitle: t('ob.step3sub'),
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
      title: t('ob.step4title'),
      subtitle: t('ob.step4sub'),
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
      title: t('ob.step5title'),
      subtitle: t('ob.step5sub'),
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
              {t('ob.step')} {step + 1} {t('ob.of')} {TOTAL_STEPS}
            </div>
            <h1 className="text-2xl font-bold text-white mb-1">{steps[step].title}</h1>
            <p className="text-gray-400">{steps[step].subtitle}</p>
          </div>

          {steps[step].content}

          {/* Submit button on last step */}
          {step === TOTAL_STEPS - 1 && (
            <>
              {mutation.isPending ? (
                <div className="mt-6 space-y-3">
                  {BUILD_STEPS.map((label, i) => (
                    <div
                      key={i}
                      className={`flex items-center gap-3 py-2 px-3 rounded-lg transition-all duration-300 ${
                        i < buildStep ? 'text-violet-300 opacity-60' :
                        i === buildStep ? 'text-white bg-violet-500/15' :
                        'text-gray-600 opacity-40'
                      }`}
                    >
                      <span className="text-lg w-6 text-center">
                        {i < buildStep ? '✓' : i === buildStep ? '⟳' : '○'}
                      </span>
                      <span className="text-sm font-medium">{label}</span>
                    </div>
                  ))}
                </div>
              ) : (
                <button
                  onClick={() => mutation.mutate()}
                  disabled={!focus}
                  className="mt-6 w-full py-3.5 bg-violet-600 hover:bg-violet-500 disabled:opacity-40
                             text-white font-semibold rounded-xl transition-colors text-base"
                >
                  {t('ob.generate')}
                </button>
              )}
            </>
          )}

          {mutation.isError && (
            <p className="mt-3 text-red-400 text-sm text-center">
              {t('ob.error')}
            </p>
          )}

          {step > 0 && (
            <button
              onClick={() => setStep(step - 1)}
              className="mt-4 w-full py-2 text-gray-500 hover:text-white text-sm transition-colors"
            >
              {t('ob.back')}
            </button>
          )}
        </div>
      </div>
    </div>
  )
}

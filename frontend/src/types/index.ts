export interface User {
  id: string
  username: string
  avatar_url?: string
  xp: number
  level: number
  streak: number
  streak_shields?: number
  last_active?: string
  language_preference: string
  daily_goal: number
  onboarding_completed: boolean
  active_tracks?: string[]  // e.g. ['junior_dev', 'umschulung']
}

export type OnboardingGoal = 'job' | 'hobby' | 'school' | 'upskill'
export type OnboardingTimeline = '1month' | '3months' | '6months' | 'no_rush'
export type OnboardingLevel = 'absolute_beginner' | 'some_basics' | 'intermediate'
export type OnboardingLanguage = 'python' | 'javascript' | 'typescript'
export type OnboardingCompany = 'startup' | 'medium' | 'large'
export type OnboardingFocus = 'frontend' | 'backend' | 'fullstack'

// ── New multi-phase training plan ──────────────────────────────────────────

export type ActivityType = 'theory' | 'coding' | 'project' | 'review' | 'interview_prep' | 'debugging'
export type DepthLevel = 'understand' | 'apply' | 'master'
export type InterviewRelevance = 'low' | 'medium' | 'high'

export interface PlanTopic {
  name: string
  subtopics: string[]
  depth: DepthLevel
  why_important: string
  interview_relevance: InterviewRelevance
}

export interface PlanActivity {
  type: ActivityType
  title: string
  description: string
  resource: string
  priority: 'must' | 'optional'
}

export interface PlanDay {
  day: string
  duration_minutes: number
  activities: PlanActivity[]
}

export interface MilestoneProject {
  title: string
  description: string
  skills_practiced: string[]
}

export interface PlanPhase {
  phase_number: number
  title: string
  duration_weeks: number
  goal: string
  topics: PlanTopic[]
  weekly_schedule: PlanDay[]
  milestone_project: MilestoneProject
  phase_complete_when: string[]
}

export interface InterviewPrepSection {
  topics: string[]
  typical_questions: string[]
  coding_challenges: string[]
}

export interface TrainingPlan {
  phases: PlanPhase[]
  interview_preparation: {
    startup: InterviewPrepSection
    medium_company: InterviewPrepSection
    large_company: InterviewPrepSection
  }
  portfolio_requirements: {
    minimum_projects: number
    must_have_features: string[]
    nice_to_have: string[]
  }
}

export interface TrainingPlanMeta {
  goal: string
  timeline: string
  level: string
  language: string
  company_target?: string
  framework_focus?: string
  current_phase: number
  created_at: string
  updated_at: string
}

// ── Interview Simulator ────────────────────────────────────────────────────

export interface InterviewMessage {
  role: 'user' | 'assistant'
  content: string
}

export interface QAPair {
  question: string
  answer: string
  evaluation: string
}

export interface InterviewSummary {
  score: number
  strongest_areas: string[]
  weakest_areas: string[]
  study_topics: string[]
  overall_feedback: string
}

export interface InterviewSession {
  id: number
  company_size: string
  focus: string
  score: number | null
  feedback: InterviewSummary | null
  completed: boolean
  completed_at: string | null
  created_at: string
}

export interface ChecklistItem {
  key: string
  label: string
  category: string
  completed: boolean
}

export interface WeeklyCheckin {
  tasks_completed: number
  tasks_total: number
  notes?: string
  created_at: string
}

export interface Topic {
  id: number
  title: string
  description?: string
  order_index: number
  icon?: string
  total_lessons: number
  completed_lessons: number
  is_locked: boolean
  is_completed: boolean
  track: string        // 'junior_dev' | 'umschulung'
  lernfeld_number?: number | null
}

export interface IHKChecklistItem {
  key: string
  label: string
  category: string
  completed: boolean
}

export type LessonType = 'theory' | 'quiz' | 'code' | 'debug' | 'advanced' | 'explain'

export interface ExplainContent {
  topic_constraints: string[]
  generated_code: string
}

export interface TheorySection {
  type: 'text' | 'code'
  content: string
  language?: string
}

export interface TheoryContent {
  sections: TheorySection[]
  summary?: string
  why_matters?: string
}

export interface QuizContent {
  question: string
  options: string[]
  correct_index: number
  explanation: string
  option_explanations?: string[]
}

export interface CodeContent {
  instructions: string
  starter_code: string
  expected_output: string
  test_cases: Array<{ description: string; expected_pattern: string }>
  hints: string[]
  solution?: string
}

export interface RecapQuestion {
  question: string
  options: string[]
  correct_index: number
  explanation: string
}

export interface ConceptRef {
  concept: string
  recap: string
}

export interface Lesson {
  id: number
  topic_id: number
  title: string
  type: LessonType
  content_json: TheoryContent | QuizContent | CodeContent | ExplainContent
  xp_reward: number
  order_index: number
  is_completed: boolean
  xp_earned: number
  language?: string
  mastery_level?: number
  concept_intro?: string | null
  glossary?: Record<string, { explanation: string; example?: string | null; example_language?: string | null }>
  learning_objectives?: string[]
  story_context?: string | null
  recap_quiz?: RecapQuestion[]
  error_context?: string | null
  concept_refs?: ConceptRef[]
}

export interface Badge {
  id: number
  name: string
  description: string
  icon: string
  earned_at?: string
}

export interface LeaderboardEntry {
  rank: number
  user_id: string
  username: string
  avatar_url?: string
  weekly_xp: number
  is_current_user: boolean
}

export interface ActivityEntry {
  date: string
  lessons_completed: number
  xp_earned: number
}

export interface DashboardData {
  username: string
  avatar_url?: string
  xp: number
  level: number
  streak: number
  streak_shields: number
  daily_goal: number
  lessons_today: number
  lessons_this_week: number
  xp_today: number
  total_lessons_completed: number
  total_lessons: number
  current_topic?: {
    id: number
    title: string
    icon?: string
    completed: number
    total: number
  }
  next_lesson?: {
    id: number
    title: string
    type: string
  }
  next_badge?: {
    id: number
    name: string
    icon: string
    progress: number
    goal_label: string
  }
  weak_topics?: Array<{ title: string; icon?: string; avg_attempts: number }>
  recent_badges: Badge[]
  activity_data: ActivityEntry[]
}

export interface ChatMessage {
  role: 'user' | 'assistant'
  content: string
}

export interface SubmitResult {
  correct: boolean
  feedback: string
  xp_earned: number
  output?: string
  error?: string
  topic_completed?: boolean
  expected_output?: string
  level?: number
  test_results?: Array<{
    description: string
    passed: boolean
    expected: string
    actual: string
    error?: string
  }>
  streak?: number
}

export interface ProfileData {
  id: string
  username: string
  avatar_url?: string
  xp: number
  level: number
  streak: number
  streak_shields?: number
  language_preference: string
  daily_goal: number
  badges: Badge[]
  total_lessons_completed: number
}

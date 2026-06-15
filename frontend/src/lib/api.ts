import axios from 'axios'
import { useUserStore } from '../store/useUserStore'
import type {
  Topic,
  Lesson,
  DashboardData,
  LeaderboardEntry,
  ProfileData,
  SubmitResult,
  ChatMessage,
  TrainingPlan,
  TrainingPlanMeta,
  ChecklistItem,
  WeeklyCheckin,
  InterviewSession,
  InterviewSummary,
  QAPair,
} from '../types'

const api = axios.create({
  baseURL: import.meta.env.VITE_API_URL || 'http://localhost:8000',
})

api.interceptors.request.use((config) => {
  const token = useUserStore.getState().token
  if (token) config.headers.Authorization = `Bearer ${token}`
  return config
})

// Topics
export async function fetchTopics(): Promise<Topic[]> {
  const { data } = await api.get<Topic[]>('/topics/')
  return data
}

export async function fetchTopicLessons(topicId: number): Promise<Lesson[]> {
  const { data } = await api.get<Lesson[]>(`/topics/${topicId}/lessons`)
  return data
}

// Lessons
export async function fetchLesson(lessonId: number): Promise<Lesson> {
  const { data } = await api.get<Lesson>(`/lessons/${lessonId}`)
  return data
}

export async function submitLesson(
  lessonId: number,
  answer: string,
  language = 'python',
): Promise<SubmitResult> {
  const { data } = await api.post<SubmitResult>(`/lessons/${lessonId}/submit`, { answer, language })
  return data
}

// AI
export async function getHint(lessonId: number, hintLevel: number, userCode: string): Promise<string> {
  const { data } = await api.post<{ hint: string }>('/ai/hint', {
    lesson_id: lessonId,
    hint_level: hintLevel,
    user_code: userCode,
  })
  return data.hint
}

export async function explainMistake(lessonId: number, userCode: string, error: string): Promise<string> {
  const { data } = await api.post<{ explanation: string }>('/ai/explain', {
    lesson_id: lessonId,
    user_code: userCode,
    error,
  })
  return data.explanation
}

export async function sendChatMessage(
  messages: ChatMessage[],
  currentTopic: string,
  language: string,
): Promise<string> {
  const { data } = await api.post<{ message: string }>('/ai/chat', {
    messages,
    current_topic: currentTopic,
    language,
  })
  return data.message
}

// User
export async function fetchDashboard(): Promise<DashboardData> {
  const { data } = await api.get<DashboardData>('/user/dashboard')
  return data
}

export async function fetchLeaderboard(): Promise<LeaderboardEntry[]> {
  const { data } = await api.get<LeaderboardEntry[]>('/leaderboard/')
  return data
}

export async function updateStreak(): Promise<{ streak: number; is_new_day: boolean }> {
  const { data } = await api.post('/user/streak')
  return data
}

export async function fetchProfile(): Promise<ProfileData> {
  const { data } = await api.get<ProfileData>('/user/profile')
  return data
}

export async function updateProfile(fields: Partial<ProfileData>): Promise<ProfileData> {
  const { data } = await api.patch<ProfileData>('/user/profile', fields)
  return data
}

// Onboarding
export async function completeOnboarding(payload: {
  goal: string
  timeline: string
  level: string
  language: string
  company_target?: string
  framework_focus?: string
}): Promise<{ plan: TrainingPlan }> {
  const { data } = await api.post('/onboarding/complete', payload)
  return data
}

// Training Plan
export async function fetchTrainingPlan(): Promise<{ plan: TrainingPlan | null; meta?: TrainingPlanMeta }> {
  const { data } = await api.get('/training-plan/')
  return data
}

export async function adjustTrainingPlan(notes: string): Promise<{ plan: TrainingPlan }> {
  const { data } = await api.post('/training-plan/adjust', { notes })
  return data
}

// Checklist
export async function fetchChecklist(): Promise<{ items: ChecklistItem[] }> {
  const { data } = await api.get('/checklist/')
  return data
}

export async function updateChecklistItem(item_key: string, completed: boolean): Promise<void> {
  await api.patch('/checklist/item', { item_key, completed })
}

export async function fetchTestQuestion(item_key: string): Promise<{ question: string; expected_answer: string }> {
  const { data } = await api.get(`/checklist/test-question/${item_key}`)
  return data
}

export async function advancePhase(phase: number): Promise<void> {
  await api.post('/training-plan/advance-phase', { phase })
}

// Interview Simulator
export async function startInterview(company_size: string, focus: string): Promise<{
  session_id: number
  evaluation: string | null
  question: string
  question_number: number
}> {
  const { data } = await api.post('/interview/start', { company_size, focus })
  return data
}

export async function sendInterviewMessage(payload: {
  session_id: number
  messages: { role: string; content: string }[]
  question_number: number
  company_size: string
  focus: string
}): Promise<{ evaluation: string | null; question: string; question_number: number }> {
  const { data } = await api.post('/interview/message', payload)
  return data
}

export async function completeInterview(payload: {
  session_id: number
  messages: { role: string; content: string }[]
  qa_pairs: QAPair[]
  company_size: string
  focus: string
}): Promise<InterviewSummary> {
  const { data } = await api.post('/interview/complete', payload)
  return data
}

export async function fetchInterviewHistory(): Promise<{ sessions: InterviewSession[] }> {
  const { data } = await api.get('/interview/history')
  return data
}

// Weekly Check-in
export async function fetchCurrentCheckin(): Promise<{
  checkin: WeeklyCheckin | null
  week: number
  year: number
}> {
  const { data } = await api.get('/weekly-checkin/current')
  return data
}

export async function submitCheckin(payload: {
  tasks_completed: number
  tasks_total: number
  notes?: string
}): Promise<void> {
  await api.post('/weekly-checkin/', payload)
}

import { create } from 'zustand'
import type { Lesson, ChatMessage } from '../types'

interface LessonState {
  currentLesson: Lesson | null
  currentTopicName: string
  hintsUsed: number
  currentHint: string | null
  isLoadingHint: boolean
  chatMessages: ChatMessage[]
  isChatOpen: boolean
  lessonStartTime: number | null

  setCurrentLesson: (lesson: Lesson | null, topicName?: string) => void
  incrementHints: () => void
  setHint: (hint: string | null) => void
  setLoadingHint: (loading: boolean) => void
  addChatMessage: (msg: ChatMessage) => void
  clearChat: () => void
  toggleChat: () => void
  startLesson: () => void
  getElapsedSeconds: () => number
  reset: () => void
}

export const useLessonStore = create<LessonState>((set, get) => ({
  currentLesson: null,
  currentTopicName: '',
  hintsUsed: 0,
  currentHint: null,
  isLoadingHint: false,
  chatMessages: [],
  isChatOpen: false,
  lessonStartTime: null,

  setCurrentLesson: (lesson, topicName = '') =>
    set({ currentLesson: lesson, currentTopicName: topicName, hintsUsed: 0, currentHint: null }),

  incrementHints: () => set((state) => ({ hintsUsed: state.hintsUsed + 1 })),

  setHint: (hint) => set({ currentHint: hint }),

  setLoadingHint: (loading) => set({ isLoadingHint: loading }),

  addChatMessage: (msg) =>
    set((state) => ({ chatMessages: [...state.chatMessages, msg] })),

  clearChat: () => set({ chatMessages: [] }),

  toggleChat: () => set((state) => ({ isChatOpen: !state.isChatOpen })),

  startLesson: () => set({ lessonStartTime: Date.now() }),

  getElapsedSeconds: () => {
    const start = get().lessonStartTime
    if (!start) return 0
    return Math.floor((Date.now() - start) / 1000)
  },

  reset: () =>
    set({
      currentLesson: null,
      currentTopicName: '',
      hintsUsed: 0,
      currentHint: null,
      isLoadingHint: false,
      lessonStartTime: null,
    }),
}))

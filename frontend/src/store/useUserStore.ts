import { create } from 'zustand'
import { persist } from 'zustand/middleware'
import type { User } from '../types'

interface UserState {
  user: User | null
  token: string | null
  isDark: boolean
  uiLanguage: 'en' | 'de'
  activeTrack: 'junior_dev' | 'umschulung'
  setUser: (user: User | null) => void
  setToken: (token: string | null) => void
  updateXP: (xp: number, level: number) => void
  updateStreak: (streak: number) => void
  toggleDark: () => void
  logout: () => void
  setUiLanguage: (lang: 'en' | 'de') => void
  setActiveTrack: (track: 'junior_dev' | 'umschulung') => void
}

export const useUserStore = create<UserState>()(
  persist(
    (set) => ({
      user: null,
      token: null,
      isDark: true,
      uiLanguage: 'en',
      activeTrack: 'junior_dev',

      setUser: (user) => set({ user }),
      setToken: (token) => set({ token }),
      logout: () => set({ user: null, token: null }),
      setActiveTrack: (track) => set({ activeTrack: track }),

      updateXP: (xp, level) =>
        set((s) => ({ user: s.user ? { ...s.user, xp, level } : null })),

      updateStreak: (streak) =>
        set((s) => ({ user: s.user ? { ...s.user, streak } : null })),

      toggleDark: () =>
        set((s) => {
          const next = !s.isDark
          document.documentElement.classList.toggle('dark', next)
          return { isDark: next }
        }),

      setUiLanguage: (lang) => set({ uiLanguage: lang }),
    }),
    {
      name: 'codequest-user',
      partialize: (s) => ({ user: s.user, token: s.token, isDark: s.isDark, uiLanguage: s.uiLanguage, activeTrack: s.activeTrack }),
    },
  ),
)

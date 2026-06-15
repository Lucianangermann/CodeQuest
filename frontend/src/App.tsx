import { useEffect } from 'react'
import { BrowserRouter, Routes, Route, Navigate } from 'react-router-dom'
import { QueryClient, QueryClientProvider } from '@tanstack/react-query'
import { useUserStore } from './store/useUserStore'

const queryClient = new QueryClient({
  defaultOptions: {
    queries: { staleTime: 30_000, retry: 1 },
  },
})

import Navbar from './components/Navbar'
import AIChat from './components/AIChat'
import JobReadyWidget from './components/JobReadyWidget'
import WeeklyReviewPopup from './components/WeeklyReviewPopup'
import Auth from './pages/Auth'
import Dashboard from './pages/Dashboard'
import Roadmap from './pages/Roadmap'
import Lesson from './pages/Lesson'
import Leaderboard from './pages/Leaderboard'
import Profile from './pages/Profile'
import Onboarding from './pages/Onboarding'
import MyPath from './pages/MyPath'
import InterviewSimulator from './pages/InterviewSimulator'
import Review from './pages/Review'

function ProtectedRoute({ children }: { children: React.ReactNode }) {
  const { token, user } = useUserStore()
  if (!token) return <Navigate to="/auth" replace />
  // Redirect to onboarding if not yet completed (strict false check preserves undefined for old sessions)
  if (user && user.onboarding_completed === false) return <Navigate to="/onboarding" replace />
  return <>{children}</>
}

export default function App() {
  const isDark = useUserStore((s) => s.isDark)

  useEffect(() => {
    document.documentElement.classList.toggle('dark', isDark)
  }, [isDark])

  return (
    <QueryClientProvider client={queryClient}>
      <BrowserRouter>
        <div className="min-h-screen bg-quest-bg flex flex-col">
          <Navbar />
          <main className="flex-1">
            <Routes>
              <Route path="/auth"       element={<Auth />} />
              <Route path="/onboarding" element={<Onboarding />} />
              <Route path="/dashboard"  element={<ProtectedRoute><Dashboard /></ProtectedRoute>} />
              <Route path="/roadmap"    element={<ProtectedRoute><Roadmap /></ProtectedRoute>} />
              <Route path="/my-path"    element={<ProtectedRoute><MyPath /></ProtectedRoute>} />
              <Route path="/interview"  element={<ProtectedRoute><InterviewSimulator /></ProtectedRoute>} />
              <Route path="/review"     element={<ProtectedRoute><Review /></ProtectedRoute>} />
              <Route path="/lesson/:lessonId" element={<ProtectedRoute><Lesson /></ProtectedRoute>} />
              <Route path="/leaderboard" element={<ProtectedRoute><Leaderboard /></ProtectedRoute>} />
              <Route path="/profile"    element={<ProtectedRoute><Profile /></ProtectedRoute>} />
              <Route path="/" element={<Navigate to="/dashboard" replace />} />
              <Route path="*" element={<Navigate to="/dashboard" replace />} />
            </Routes>
          </main>
          <AIChat />
          <JobReadyWidget />
          <WeeklyReviewPopup />
        </div>
      </BrowserRouter>
    </QueryClientProvider>
  )
}

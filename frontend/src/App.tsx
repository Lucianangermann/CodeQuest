import { lazy, Suspense, useEffect } from 'react'
import { BrowserRouter, Routes, Route, Navigate } from 'react-router-dom'
import { QueryClient, QueryClientProvider } from '@tanstack/react-query'
import { useUserStore } from './store/useUserStore'

const queryClient = new QueryClient({
  defaultOptions: {
    queries: { staleTime: 30_000, retry: 1 },
  },
})

import Navbar from './components/Navbar'
import BottomNav from './components/BottomNav'
import AIChat from './components/AIChat'
import JobReadyWidget from './components/JobReadyWidget'
import WeeklyReviewPopup from './components/WeeklyReviewPopup'

const Auth = lazy(() => import('./pages/Auth'))
const Dashboard = lazy(() => import('./pages/Dashboard'))
const Roadmap = lazy(() => import('./pages/Roadmap'))
const Lesson = lazy(() => import('./pages/Lesson'))
const Leaderboard = lazy(() => import('./pages/Leaderboard'))
const Profile = lazy(() => import('./pages/Profile'))
const Onboarding = lazy(() => import('./pages/Onboarding'))
const MyPath = lazy(() => import('./pages/MyPath'))
const InterviewSimulator = lazy(() => import('./pages/InterviewSimulator'))
const Review = lazy(() => import('./pages/Review'))
const Playground = lazy(() => import('./pages/Playground'))
const Capstone = lazy(() => import('./pages/Capstone'))
const GitHubGuide = lazy(() => import('./pages/GitHubGuide'))

function PageLoader() {
  return (
    <div className="flex items-center justify-center min-h-[60vh]">
      <div className="w-8 h-8 border-2 border-quest-purple border-t-transparent rounded-full animate-spin" />
    </div>
  )
}

function ProtectedRoute({ children }: { children: React.ReactNode }) {
  const { token, user } = useUserStore()
  if (!token) return <Navigate to="/auth" replace />
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
          <main className="flex-1 pb-16 md:pb-0">
            <Suspense fallback={<PageLoader />}>
              <Routes>
                <Route path="/auth"       element={<Auth />} />
                <Route path="/onboarding" element={<Onboarding />} />
                <Route path="/dashboard"  element={<ProtectedRoute><Dashboard /></ProtectedRoute>} />
                <Route path="/roadmap"    element={<ProtectedRoute><Roadmap /></ProtectedRoute>} />
                <Route path="/my-path"    element={<ProtectedRoute><MyPath /></ProtectedRoute>} />
                <Route path="/interview"  element={<ProtectedRoute><InterviewSimulator /></ProtectedRoute>} />
                <Route path="/review"     element={<ProtectedRoute><Review /></ProtectedRoute>} />
                <Route path="/playground" element={<ProtectedRoute><Playground /></ProtectedRoute>} />
                <Route path="/lesson/:lessonId" element={<ProtectedRoute><Lesson /></ProtectedRoute>} />
                <Route path="/leaderboard" element={<ProtectedRoute><Leaderboard /></ProtectedRoute>} />
                <Route path="/profile"    element={<ProtectedRoute><Profile /></ProtectedRoute>} />
                <Route path="/capstone"   element={<ProtectedRoute><Capstone /></ProtectedRoute>} />
                <Route path="/github"     element={<ProtectedRoute><GitHubGuide /></ProtectedRoute>} />
                <Route path="/" element={<Navigate to="/dashboard" replace />} />
                <Route path="*" element={<Navigate to="/dashboard" replace />} />
              </Routes>
            </Suspense>
          </main>
          <AIChat />
          <JobReadyWidget />
          <WeeklyReviewPopup />
          <BottomNav />
        </div>
      </BrowserRouter>
    </QueryClientProvider>
  )
}

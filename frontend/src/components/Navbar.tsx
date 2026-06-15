import { Link, useLocation, useNavigate } from 'react-router-dom'
import { motion } from 'framer-motion'
import { LayoutDashboard, Map, Route, Mic, Trophy, User, LogOut, Sun, Moon, Zap, Brain, Code2 } from 'lucide-react'
import { supabase } from '../lib/supabase'
import { useUserStore } from '../store/useUserStore'
import toast from 'react-hot-toast'

const NAV_ITEMS = [
  { path: '/dashboard',  label: 'Dashboard',   icon: LayoutDashboard },
  { path: '/roadmap',    label: 'Roadmap',      icon: Map },
  { path: '/my-path',   label: 'My Path',      icon: Route },
  { path: '/interview',  label: 'Interview',    icon: Mic },
  { path: '/review',     label: 'Review',       icon: Brain },
  { path: '/playground', label: 'Playground',   icon: Code2 },
  { path: '/leaderboard',label: 'Leaderboard', icon: Trophy },
  { path: '/profile',    label: 'Profile',      icon: User },
]

export default function Navbar() {
  const location = useLocation()
  const navigate = useNavigate()
  const { user, isDark, toggleDark } = useUserStore()

  if (!user) return null

  async function handleLogout() {
    await supabase.auth.signOut()
    navigate('/auth')
    toast.success('Logged out successfully')
  }

  const xpToNextLevel = (user.level * 100) - user.xp
  const xpProgress = ((user.xp % 100) / 100) * 100

  return (
    <nav className="sticky top-0 z-40 relative" style={{
      background: 'rgba(8, 9, 26, 0.92)',
      backdropFilter: 'blur(20px)',
      WebkitBackdropFilter: 'blur(20px)',
      borderBottom: '1px solid rgba(124, 58, 237, 0.25)',
      boxShadow: '0 4px 32px rgba(0, 0, 0, 0.5), 0 1px 0 rgba(124,58,237,0.1) inset',
    }}>
      <div className="absolute bottom-0 left-0 right-0 h-px" style={{ background: 'linear-gradient(90deg, transparent, rgba(124,58,237,0.6), rgba(99,102,241,0.6), transparent)' }} />
      <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
        <div className="flex items-center justify-between h-16">
          {/* Logo */}
          <Link to="/dashboard" className="flex items-center gap-2.5">
            <div className="w-8 h-8 rounded-xl flex items-center justify-center flex-shrink-0"
              style={{ background: 'linear-gradient(135deg, #7c3aed 0%, #6366f1 100%)', boxShadow: '0 0 16px rgba(124,58,237,0.4)' }}>
              <Zap className="w-4 h-4 text-white" />
            </div>
            <span className="font-bold text-lg hidden sm:block"
              style={{ background: 'linear-gradient(135deg, #9d5cf6 0%, #818cf8 100%)', WebkitBackgroundClip: 'text', WebkitTextFillColor: 'transparent' }}>
              CodeQuest
            </span>
          </Link>

          {/* Desktop nav */}
          <div className="hidden md:flex items-center gap-1">
            {NAV_ITEMS.map(({ path, label, icon: Icon }) => {
              const isActive = location.pathname === path
              return (
                <Link
                  key={path}
                  to={path}
                  className={`relative flex items-center gap-2 px-4 py-2 rounded-xl text-sm font-medium transition-all duration-200 ${
                    isActive
                      ? 'text-white border border-quest-purple/40'
                      : 'text-quest-muted hover:text-quest-text hover:bg-white/5 border border-transparent'
                  }`}
                >
                  <Icon className="w-4 h-4" />
                  {label}
                  {isActive && (
                    <motion.div
                      layoutId="nav-indicator"
                      className="absolute inset-0 rounded-xl"
                      style={{ background: 'linear-gradient(135deg, rgba(124,58,237,0.25) 0%, rgba(99,102,241,0.15) 100%)', boxShadow: '0 0 12px rgba(124,58,237,0.15) inset' }}
                    />
                  )}
                </Link>
              )
            })}
          </div>

          {/* Right side: XP, level, theme, logout */}
          <div className="flex items-center gap-3">
            {/* Level + XP bar */}
            <div className="hidden sm:flex flex-col items-end gap-0.5">
              <div className="flex items-center gap-2 text-xs text-quest-muted">
                <span className="font-bold text-xs px-1.5 py-0.5 rounded-md"
                  style={{ background: 'linear-gradient(135deg, #7c3aed22 0%, #6366f122 100%)', color: '#9d5cf6', boxShadow: '0 0 8px rgba(124,58,237,0.2)' }}>
                  Lv.{user.level}
                </span>
                <span>{user.xp} XP</span>
              </div>
              <div className="w-20 bg-quest-border/30 rounded-full h-1.5">
                <div className="h-1.5 rounded-full" style={{ width: `${xpProgress}%`, background: 'linear-gradient(90deg, #7c3aed 0%, #818cf8 100%)', boxShadow: '0 0 6px rgba(124,58,237,0.5)' }} />
              </div>
              <span className="text-xs text-quest-muted">{xpToNextLevel} XP to next level</span>
            </div>

            {/* Streak */}
            <span className="flex items-center gap-1 text-sm font-bold px-2 py-1 rounded-lg bg-orange-500/10 border border-orange-500/20 text-orange-400">
              🔥 {user.streak}
            </span>

            {/* Dark mode toggle */}
            <button
              onClick={toggleDark}
              className="p-2 rounded-xl text-quest-muted hover:text-quest-text hover:bg-quest-border transition-all"
              aria-label="Toggle theme"
            >
              {isDark ? <Sun className="w-4 h-4" /> : <Moon className="w-4 h-4" />}
            </button>

            {/* Logout */}
            <button
              onClick={handleLogout}
              className="p-2 rounded-xl text-quest-muted hover:text-red-400 hover:bg-red-400/10 transition-all"
              aria-label="Logout"
            >
              <LogOut className="w-4 h-4" />
            </button>
          </div>
        </div>

        {/* Mobile nav */}
        <div className="md:hidden flex justify-around pb-2">
          {NAV_ITEMS.map(({ path, label, icon: Icon }) => {
            const isActive = location.pathname === path
            return (
              <Link
                key={path}
                to={path}
                className={`flex flex-col items-center gap-0.5 px-3 py-1.5 rounded-xl text-xs transition-all relative ${
                  isActive ? 'text-quest-purple-light' : 'text-quest-muted'
                }`}
              >
                {isActive && (
                  <span className="absolute -top-0.5 left-1/2 -translate-x-1/2 w-1 h-1 rounded-full bg-quest-purple-light" />
                )}
                <Icon className="w-5 h-5" />
                {label}
              </Link>
            )
          })}
        </div>
      </div>
    </nav>
  )
}

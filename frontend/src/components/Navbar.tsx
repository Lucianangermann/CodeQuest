import { Link, useLocation, useNavigate } from 'react-router-dom'
import { motion } from 'framer-motion'
import { LayoutDashboard, Map, Route, Mic, Trophy, User, LogOut, Sun, Moon, Zap } from 'lucide-react'
import { supabase } from '../lib/supabase'
import { useUserStore } from '../store/useUserStore'
import toast from 'react-hot-toast'

const NAV_ITEMS = [
  { path: '/dashboard',  label: 'Dashboard',   icon: LayoutDashboard },
  { path: '/roadmap',    label: 'Roadmap',      icon: Map },
  { path: '/my-path',   label: 'My Path',      icon: Route },
  { path: '/interview',  label: 'Interview',    icon: Mic },
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
    <nav className="bg-quest-card border-b border-quest-border sticky top-0 z-40">
      <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
        <div className="flex items-center justify-between h-16">
          {/* Logo */}
          <Link to="/dashboard" className="flex items-center gap-2">
            <div className="w-8 h-8 bg-quest-purple rounded-lg flex items-center justify-center">
              <Zap className="w-5 h-5 text-white" />
            </div>
            <span className="font-bold text-xl text-white hidden sm:block">CodeQuest</span>
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
                      ? 'text-quest-purple-light bg-quest-purple/10'
                      : 'text-quest-muted hover:text-quest-text hover:bg-quest-border/50'
                  }`}
                >
                  <Icon className="w-4 h-4" />
                  {label}
                  {isActive && (
                    <motion.div
                      layoutId="nav-indicator"
                      className="absolute inset-0 rounded-xl border border-quest-purple/30"
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
                <span className="text-quest-purple-light font-bold">Lv.{user.level}</span>
                <span>{user.xp} XP</span>
              </div>
              <div className="w-24 xp-bar">
                <div className="xp-fill" style={{ width: `${xpProgress}%` }} />
              </div>
              <span className="text-xs text-quest-muted">{xpToNextLevel} XP to next level</span>
            </div>

            {/* Streak */}
            <div className="flex items-center gap-1 text-quest-yellow">
              <span>🔥</span>
              <span className="text-sm font-bold">{user.streak}</span>
            </div>

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
                className={`flex flex-col items-center gap-0.5 px-3 py-1.5 rounded-xl text-xs transition-all ${
                  isActive ? 'text-quest-purple-light' : 'text-quest-muted'
                }`}
              >
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

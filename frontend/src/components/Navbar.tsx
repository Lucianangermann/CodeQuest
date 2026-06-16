import { Link, useLocation, useNavigate } from 'react-router-dom'
import { motion } from 'framer-motion'
import { LayoutDashboard, Map, Route, Mic, Trophy, User, LogOut, Sun, Moon, Zap, Brain, Code2 } from 'lucide-react'
import { supabase } from '../lib/supabase'
import { useUserStore } from '../store/useUserStore'
import { useT } from '../i18n/useT'
import toast from 'react-hot-toast'

export default function Navbar() {
  const location = useLocation()
  const navigate = useNavigate()
  const { user, isDark, toggleDark, uiLanguage, setUiLanguage } = useUserStore()
  const t = useT()

  const NAV_ITEMS = [
    { path: '/dashboard',   label: t('nav.dashboard'),   icon: LayoutDashboard },
    { path: '/roadmap',     label: t('nav.roadmap'),     icon: Map },
    { path: '/my-path',     label: t('nav.myPath'),      icon: Route },
    { path: '/interview',   label: t('nav.interview'),   icon: Mic },
    { path: '/review',      label: t('nav.review'),      icon: Brain },
    { path: '/playground',  label: t('nav.playground'),  icon: Code2 },
    { path: '/leaderboard', label: t('nav.leaderboard'), icon: Trophy },
    { path: '/profile',     label: t('nav.profile'),     icon: User },
  ]

  if (!user) return null

  async function handleLogout() {
    await supabase.auth.signOut()
    navigate('/auth')
    toast.success(t('nav.loggedOut'))
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
              <span className="text-xs text-quest-muted">{xpToNextLevel} {t('nav.xpToNext')}</span>
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

            {/* Language toggle */}
            <button
              onClick={() => setUiLanguage(uiLanguage === 'en' ? 'de' : 'en')}
              className="px-2 py-1 rounded-xl text-xs font-bold text-quest-muted hover:text-quest-text hover:bg-quest-border transition-all"
              aria-label="Toggle language"
            >
              {uiLanguage === 'en' ? 'DE' : 'EN'}
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

      </div>
    </nav>
  )
}

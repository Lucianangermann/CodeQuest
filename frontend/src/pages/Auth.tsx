import { useState } from 'react'
import { Navigate } from 'react-router-dom'
import { motion } from 'framer-motion'
import { Zap, Lock, User, Loader2 } from 'lucide-react'
import { apiLogin, apiSignup } from '../lib/auth'
import { useUserStore } from '../store/useUserStore'
import { useT } from '../i18n/useT'
import { updateStreak } from '../lib/api'
import toast from 'react-hot-toast'

export default function Auth() {
  const { user, setUser, setToken } = useUserStore()
  const t = useT()
  const [mode, setMode] = useState<'login' | 'signup'>('login')
  const [password, setPassword] = useState('')
  const [username, setUsername] = useState('')
  const [loading, setLoading] = useState(false)

  if (user) return <Navigate to="/dashboard" replace />

  async function handleSubmit(e: React.FormEvent) {
    e.preventDefault()
    setLoading(true)
    try {
      const result =
        mode === 'signup'
          ? await apiSignup(username, password)
          : await apiLogin(username, password)

      setToken(result.token)
      setUser(result.user as any)
      try { await updateStreak() } catch { /* best-effort */ }

      toast.success(mode === 'login' ? t('auth.welcomeBack') : t('auth.accountCreated'))
    } catch (err: any) {
      toast.error(err?.response?.data?.detail || t('auth.error'))
    } finally {
      setLoading(false)
    }
  }

  return (
    <div className="min-h-screen flex items-center justify-center px-4 bg-quest-bg">
      <div className="absolute inset-0 overflow-hidden pointer-events-none">
        <div className="absolute top-1/4 left-1/2 -translate-x-1/2 w-96 h-96 bg-quest-purple/10 rounded-full blur-3xl" />
      </div>

      <motion.div
        initial={{ opacity: 0, y: 24 }}
        animate={{ opacity: 1, y: 0 }}
        transition={{ duration: 0.4 }}
        className="w-full max-w-sm relative z-10"
      >
        <div className="text-center mb-8">
          <div className="w-16 h-16 rounded-2xl flex items-center justify-center mx-auto mb-4"
            style={{ background: 'linear-gradient(135deg, #7c3aed 0%, #6366f1 100%)', boxShadow: '0 0 32px rgba(124,58,237,0.5)' }}>
            <Zap className="w-9 h-9 text-white" />
          </div>
          <h1 className="text-3xl font-bold"
            style={{ background: 'linear-gradient(135deg, #9d5cf6 0%, #818cf8 100%)', WebkitBackgroundClip: 'text', WebkitTextFillColor: 'transparent', backgroundClip: 'text' }}>
            CodeQuest
          </h1>
          <p className="text-quest-muted mt-1">{t('auth.tagline')}</p>
        </div>

        <div className="card">
          <div className="flex bg-quest-bg rounded-xl p-1 mb-6">
            {(['login', 'signup'] as const).map((m) => (
              <button
                key={m}
                onClick={() => setMode(m)}
                className={`flex-1 py-2 rounded-lg text-sm font-semibold transition-all ${
                  mode === m
                    ? 'bg-quest-purple text-white shadow-sm'
                    : 'text-quest-muted hover:text-quest-text'
                }`}
              >
                {m === 'login' ? t('auth.login') : t('auth.signup')}
              </button>
            ))}
          </div>

          <form onSubmit={handleSubmit} className="space-y-4">
            <div className="relative">
              <User className="absolute left-3 top-1/2 -translate-y-1/2 w-4 h-4 text-quest-muted" />
              <input
                type="text"
                placeholder={t('auth.username')}
                value={username}
                onChange={(e) => setUsername(e.target.value)}
                required
                className="input pl-10"
              />
            </div>

            <div className="relative">
              <Lock className="absolute left-3 top-1/2 -translate-y-1/2 w-4 h-4 text-quest-muted" />
              <input
                type="password"
                placeholder={t('auth.password')}
                value={password}
                onChange={(e) => setPassword(e.target.value)}
                required
                minLength={6}
                className="input pl-10"
              />
            </div>

            <button
              type="submit"
              disabled={loading}
              className="btn-primary w-full flex items-center justify-center gap-2"
            >
              {loading && <Loader2 className="w-4 h-4 animate-spin" />}
              {mode === 'login' ? t('auth.login') : t('auth.createAccount')}
            </button>
          </form>
        </div>
      </motion.div>
    </div>
  )
}

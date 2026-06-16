import { Link, useLocation } from 'react-router-dom'
import { LayoutDashboard, Map, Brain, Code2, User } from 'lucide-react'
import { useQuery } from '@tanstack/react-query'
import { useUserStore } from '../store/useUserStore'
import { fetchDueReviewCount } from '../lib/api'

const NAV_ITEMS = [
  { path: '/dashboard',  label: 'Dashboard', icon: LayoutDashboard },
  { path: '/roadmap',    label: 'Roadmap',   icon: Map },
  { path: '/review',     label: 'Review',    icon: Brain },
  { path: '/playground', label: 'Playground',icon: Code2 },
  { path: '/profile',    label: 'Profile',   icon: User },
]

export default function BottomNav() {
  const location = useLocation()
  const user = useUserStore((s) => s.user)

  const { data: reviewCount = 0 } = useQuery({
    queryKey: ['review-count'],
    queryFn: fetchDueReviewCount,
    retry: false,
    enabled: !!user,
  })

  if (!user) return null

  return (
    <nav
      className="md:hidden fixed bottom-0 left-0 right-0 z-40 flex items-center justify-around h-16"
      style={{
        background: 'rgba(8, 9, 26, 0.95)',
        backdropFilter: 'blur(20px)',
        WebkitBackdropFilter: 'blur(20px)',
        borderTop: '1px solid rgba(124, 58, 237, 0.25)',
        boxShadow: '0 -4px 32px rgba(0,0,0,0.5)',
        paddingBottom: 'env(safe-area-inset-bottom)',
      }}
    >
      {NAV_ITEMS.map(({ path, label, icon: Icon }) => {
        const isActive = location.pathname === path
        const showBadge = path === '/review' && reviewCount > 0

        return (
          <Link
            key={path}
            to={path}
            className="relative flex flex-col items-center gap-0.5 px-3 py-1 text-xs font-medium transition-all duration-200"
            style={isActive ? {
              background: 'linear-gradient(135deg, #9d5cf6 0%, #818cf8 100%)',
              WebkitBackgroundClip: 'text',
              WebkitTextFillColor: 'transparent',
            } : { color: 'rgba(148, 163, 184, 0.7)' }}
          >
            {isActive && (
              <span
                className="absolute top-0 left-1/2 -translate-x-1/2 w-8 h-0.5 rounded-full"
                style={{ background: 'linear-gradient(90deg, #7c3aed 0%, #818cf8 100%)' }}
              />
            )}
            <span className="relative">
              <Icon className="w-5 h-5" style={isActive ? { stroke: 'url(#grad)' } : {}} />
              {showBadge && (
                <span
                  className="absolute -top-1.5 -right-2 min-w-[16px] h-4 px-1 flex items-center justify-center rounded-full text-white text-[10px] font-bold"
                  style={{ background: 'linear-gradient(135deg, #7c3aed 0%, #6366f1 100%)' }}
                >
                  {reviewCount > 99 ? '99+' : reviewCount}
                </span>
              )}
            </span>
            <span>{label}</span>
          </Link>
        )
      })}
    </nav>
  )
}

import { useState, useEffect } from 'react'
import { useQuery, useMutation, useQueryClient } from '@tanstack/react-query'
import { X, Star, RefreshCw } from 'lucide-react'
import { useNavigate } from 'react-router-dom'
import { fetchCurrentCheckin, submitCheckin, fetchTrainingPlan, fetchDashboard } from '../lib/api'
import { useUserStore } from '../store/useUserStore'

export default function WeeklyReviewPopup() {
  const user = useUserStore((s) => s.user)
  const navigate = useNavigate()
  const qc = useQueryClient()
  const [visible, setVisible] = useState(false)
  const [notes, setNotes] = useState('')

  const isSunday = new Date().getDay() === 0

  const { data: checkinData } = useQuery({
    queryKey: ['weekly-checkin-current'],
    queryFn: fetchCurrentCheckin,
    enabled: !!user?.onboarding_completed && isSunday,
  })

  const { data: planData } = useQuery({
    queryKey: ['training-plan'],
    queryFn: fetchTrainingPlan,
    enabled: !!user?.onboarding_completed,
  })

  const { data: dashboardData } = useQuery({
    queryKey: ['dashboard'],
    queryFn: fetchDashboard,
    enabled: !!user?.onboarding_completed,
  })

  const lessonsThisWeek = dashboardData?.lessons_this_week ?? 0

  useEffect(() => {
    if (isSunday && user?.onboarding_completed && checkinData && !checkinData.checkin && planData?.plan) {
      setVisible(true)
    }
  }, [isSunday, user?.onboarding_completed, checkinData, planData])

  const submitMutation = useMutation({
    mutationFn: () =>
      submitCheckin({
        tasks_completed: lessonsThisWeek,
        tasks_total: lessonsThisWeek,
        notes: notes || undefined,
      }),
    onSuccess: () => {
      qc.invalidateQueries({ queryKey: ['weekly-checkin-current'] })
      setVisible(false)
    },
  })

  const handleAdjust = async () => {
    await submitMutation.mutateAsync()
    navigate('/my-path')
  }

  if (!visible) return null

  return (
    <div className="fixed inset-0 bg-black/60 backdrop-blur-sm z-50 flex items-center justify-center p-4">
      <div className="bg-quest-card border border-white/10 rounded-2xl w-full max-w-md shadow-2xl">
        <div className="flex items-center justify-between p-5 border-b border-white/10">
          <div className="flex items-center gap-2">
            <Star size={18} className="text-amber-400" />
            <h2 className="font-semibold text-white">Weekly Review</h2>
          </div>
          <button onClick={() => setVisible(false)} className="text-gray-400 hover:text-white">
            <X size={20} />
          </button>
        </div>

        <div className="p-5 space-y-5">
          <p className="text-gray-300">
            Great job making it to Sunday! How did this week go?
          </p>

          {lessonsThisWeek > 0 && (
            <div className="bg-white/5 rounded-xl p-4 text-center">
              <div className="text-4xl font-bold text-white mb-1">
                {lessonsThisWeek}
              </div>
              <div className="text-gray-400 text-sm">lessons completed this week</div>
            </div>
          )}

          <div>
            <label className="text-sm text-gray-400 block mb-2">
              Anything to note? (optional)
            </label>
            <textarea
              value={notes}
              onChange={(e) => setNotes(e.target.value)}
              placeholder="What went well? What was hard?"
              rows={3}
              className="w-full bg-white/5 border border-white/10 rounded-lg px-3 py-2 text-white text-sm
                         placeholder-gray-500 resize-none focus:outline-none focus:border-violet-500/50"
            />
          </div>

          <div className="flex gap-3">
            <button
              onClick={handleAdjust}
              disabled={submitMutation.isPending}
              className="flex-1 flex items-center justify-center gap-2 py-2.5 border border-violet-500/50
                         text-violet-400 hover:bg-violet-500/10 rounded-xl text-sm font-medium transition-colors"
            >
              <RefreshCw size={14} />
              Adjust My Plan
            </button>
            <button
              onClick={() => submitMutation.mutate()}
              disabled={submitMutation.isPending}
              className="flex-1 py-2.5 bg-violet-600 hover:bg-violet-500 text-white text-sm
                         font-medium rounded-xl transition-colors disabled:opacity-50"
            >
              {submitMutation.isPending ? 'Saving...' : 'Keep Going! →'}
            </button>
          </div>
        </div>
      </div>
    </div>
  )
}

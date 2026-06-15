// Supabase has been replaced by a self-contained backend with local auth.
// This stub exists so any remaining references (e.g. Navbar logout) still work.
import { useUserStore } from '../store/useUserStore'

export const supabase = {
  auth: {
    signOut: async () => {
      useUserStore.getState().logout()
      window.location.href = '/auth'
    },
    // No-ops — auth state is now managed by useUserStore + JWT
    getSession: async () => ({ data: { session: null } }),
    onAuthStateChange: () => ({
      data: { subscription: { unsubscribe: () => {} } },
    }),
  },
}

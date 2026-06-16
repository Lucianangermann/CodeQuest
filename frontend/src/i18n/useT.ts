import { useUserStore } from '../store/useUserStore'
import { translations } from './translations'

export function useT() {
  const uiLanguage = useUserStore((s) => s.uiLanguage)
  return (key: string, fallback?: string): string => {
    return translations[uiLanguage]?.[key] ?? translations.en[key] ?? fallback ?? key
  }
}

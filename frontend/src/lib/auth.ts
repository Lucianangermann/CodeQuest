import axios from 'axios'

export interface AuthUser {
  id: string
  email?: string | null
  username: string
  xp: number
  level: number
  streak: number
  language_preference: string
  daily_goal: number
  avatar_url?: string
}

export interface AuthResponse {
  token: string
  user: AuthUser
}

export async function apiSignup(username: string, password: string): Promise<AuthResponse> {
  const { data } = await axios.post<AuthResponse>('/api/auth/signup', { username, password })
  return data
}

export async function apiLogin(username: string, password: string): Promise<AuthResponse> {
  const { data } = await axios.post<AuthResponse>('/api/auth/login', { username, password })
  return data
}

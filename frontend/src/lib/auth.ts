import axios from 'axios'

const BASE = import.meta.env.VITE_API_URL || 'http://localhost:8000'

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
  const { data } = await axios.post<AuthResponse>(`${BASE}/auth/signup`, {
    username,
    password,
  })
  return data
}

export async function apiLogin(username: string, password: string): Promise<AuthResponse> {
  const { data } = await axios.post<AuthResponse>(`${BASE}/auth/login`, { username, password })
  return data
}

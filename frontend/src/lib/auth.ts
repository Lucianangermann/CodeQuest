import axios from 'axios'

const BASE = import.meta.env.VITE_API_URL || 'http://localhost:8000'

export interface AuthUser {
  id: string
  email: string
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

export async function apiSignup(
  email: string,
  password: string,
  username: string,
): Promise<AuthResponse> {
  const { data } = await axios.post<AuthResponse>(`${BASE}/auth/signup`, {
    email,
    password,
    username,
  })
  return data
}

export async function apiLogin(email: string, password: string): Promise<AuthResponse> {
  const { data } = await axios.post<AuthResponse>(`${BASE}/auth/login`, { email, password })
  return data
}

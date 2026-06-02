'use client'

import { useState } from 'react'
import { useRouter } from 'next/navigation'
import api from '@/lib/api'

type Tab = 'login' | 'register'

export default function LoginPage() {
  const router = useRouter()
  const [tab, setTab] = useState<Tab>('login')
  const [email, setEmail] = useState('')
  const [password, setPassword] = useState('')
  const [error, setError] = useState('')
  const [loading, setLoading] = useState(false)

  async function handleSubmit(e: React.FormEvent) {
    e.preventDefault()
    setError('')
    setLoading(true)
    try {
      // API CALL: POST /api/auth/login  → body: { email, password } → { token, email }
      // API CALL: POST /api/auth/register → body: { email, password } → { token, email }
      const endpoint = tab === 'login' ? '/api/auth/login' : '/api/auth/register'
      const { data } = await api.post(endpoint, { email, password })
      localStorage.setItem('token', data.token)
      localStorage.setItem('userEmail', data.email)
      localStorage.removeItem('isDemo')
      router.push('/dashboard')
    } catch (err: unknown) {
      const msg =
        err && typeof err === 'object' && 'response' in err
          ? (err as { response?: { data?: { message?: string } } }).response?.data?.message
          : undefined
      setError(msg || (tab === 'login' ? 'Invalid email or password' : 'Registration failed'))
    } finally {
      setLoading(false)
    }
  }

  async function handleDemo() {
    // TODO: Create a real demo account (demo@fintrack.com / demo123) in the backend
    //       so this button logs in with real pre-seeded data.
    //       For now it falls back to mock mode so you can preview the UI.
    try {
      const { data } = await api.post('/api/auth/login', {
        email: 'demo@fintrack.com',
        password: 'demo123',
      })
      localStorage.setItem('token', data.token)
      localStorage.setItem('userEmail', data.email)
      localStorage.removeItem('isDemo')
    } catch {
      // Backend has no demo account yet — use mock mode
      localStorage.setItem('token', 'demo-mock-token')
      localStorage.setItem('isDemo', 'true')
    }
    router.push('/dashboard')
  }

  function switchTab(t: Tab) {
    setTab(t)
    setError('')
  }

  return (
    // grid place-items-center → centers the card both horizontally and vertically
    <div className="min-h-screen grid place-items-center bg-[#0a0a0a] p-6">

      {/* grid gap-6 → uniform vertical spacing between every section in the card */}
      <div className="grid gap-6 w-full max-w-sm bg-[#111] rounded-2xl border border-[#2a2a2a] p-8 shadow-2xl">

        {/* Logo */}
        <div className="grid gap-1">
          <h1 className="text-5xl font-serif tracking-tight leading-tight">
            <span className="text-green-400">Fin</span>
            <span className="text-white">Track</span>
          </h1>
          <p className="text-gray-500 font-mono text-sm">// AI-powered finance tracker</p>
        </div>

        {/* Tab switcher — stays flex internally so the sliding pill math works */}
        <div className="relative flex bg-[#1e1e1e] rounded-full p-1 border border-[#2a2a2a]">
          {/* sliding pill */}
          <div
            className="absolute inset-y-1 bg-[#d9d9d9] rounded-full shadow-sm transition-all duration-300 ease-in-out"
            style={{
              width: 'calc(50% - 4px)',
              left: tab === 'login' ? '4px' : '50%',
            }}
          />
          {(['login', 'register'] as const).map((t) => (
            <button
              key={t}
              type="button"
              onClick={() => switchTab(t)}
              className={`relative z-10 flex-1 py-2.5 rounded-full text-sm font-medium transition-colors duration-200 ${
                tab === t ? 'text-black' : 'text-gray-500 hover:text-gray-300'
              }`}
            >
              {t}
            </button>
          ))}
        </div>

        {/* Demo button */}
        <button
          type="button"
          onClick={handleDemo}
          className="w-full py-2.5 rounded-xl bg-[#1a3320] border border-green-900 text-white font-medium hover:bg-[#1f3d27] active:bg-[#162b1c] transition-colors"
        >
          Try Demo Account
        </button>

        {/* Section label */}
        <p className="text-center text-white font-mono text-sm tracking-wide">
          {tab === 'login' ? '_ sign in _' : '_ create account _'}
        </p>

        {/* Form — grid gap-4 between fields, grid gap-2 inside each field */}
        <form onSubmit={handleSubmit} className="grid gap-4">

          <div className="grid gap-2">
            <label className="text-xs font-bold text-white uppercase tracking-widest">
              Email
            </label>
            <input
              type="email"
              value={email}
              onChange={(e) => setEmail(e.target.value)}
              autoComplete="email"
              required
              className="bg-[#2d2d2d] rounded-xl px-4 py-2.5 text-white placeholder-gray-600 outline-none focus:ring-2 focus:ring-green-700 transition-all"
            />
          </div>

          <div className="grid gap-2">
            <label className="text-xs font-bold text-white uppercase tracking-widest">
              Password
            </label>
            <input
              type="password"
              value={password}
              onChange={(e) => setPassword(e.target.value)}
              autoComplete={tab === 'login' ? 'current-password' : 'new-password'}
              required
              className="bg-[#2d2d2d] rounded-xl px-4 py-2.5 text-white placeholder-gray-600 outline-none focus:ring-2 focus:ring-green-700 transition-all"
            />
          </div>

          {error && (
            <p className="text-red-400 text-sm text-center">{error}</p>
          )}

          <button
            type="submit"
            disabled={loading}
            className="w-full py-2.5 rounded-full bg-green-500 text-black font-semibold text-lg hover:bg-green-400 active:bg-green-600 transition-colors disabled:opacity-50"
          >
            {loading ? '...' : tab === 'login' ? 'Sign In' : 'Create Account'}
          </button>

        </form>

      </div>
    </div>
  )
}

'use client'

import { useRouter } from 'next/navigation'
import { useState } from 'react'
import api from '@/lib/api'

export default function DemoButton({ className }: { className?: string }) {
  const router = useRouter()
  const [loading, setLoading] = useState(false)
  const [error, setError] = useState('')

  async function handleDemo() {
    setLoading(true)
    setError('')
    try {
      const { data } = await api.post('/api/auth/login', {
        email: 'demo@fintrack.com',
        password: 'demo1234',
      })
      localStorage.setItem('token', data.token)
    localStorage.setItem('userEmail', 'demo@fintrack.com')
    localStorage.removeItem('isDemo')
    router.push('/dashboard')
    } catch {
      setError('Demo account unavailable right now.')
      setLoading(false)
    }
  }

  return (
    <div className="grid gap-2 justify-items-center">
      <button onClick={handleDemo} disabled={loading} className={className}>
        {loading ? 'Loading...' : 'Try Demo Account'}
      </button>
      {error && <p className="text-red-400 text-xs font-mono">{error}</p>}
    </div>
  )
}

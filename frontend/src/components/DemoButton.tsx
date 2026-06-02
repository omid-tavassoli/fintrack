'use client'

import { useRouter } from 'next/navigation'
import { useState } from 'react'
import api from '@/lib/api'

export default function DemoButton({ className }: { className?: string }) {
  const router = useRouter()
  const [loading, setLoading] = useState(false)

  async function handleDemo() {
    setLoading(true)
    try {
      // Try real demo account first
      const { data } = await api.post('/api/auth/login', {
        email: 'demo@fintrack.com',
        password: 'demo123',
      })
      localStorage.setItem('token', data.token)
      localStorage.setItem('userEmail', data.email)
      localStorage.removeItem('isDemo')
    } catch {
      // Fall back to mock mode
      localStorage.setItem('token', 'demo-mock-token')
      localStorage.setItem('userEmail', 'demo@fintrack.com')
      localStorage.setItem('isDemo', 'true')
    }
    router.push('/dashboard')
  }

  return (
    <button onClick={handleDemo} disabled={loading} className={className}>
      {loading ? 'Loading...' : 'Try Demo Account'}
    </button>
  )
}

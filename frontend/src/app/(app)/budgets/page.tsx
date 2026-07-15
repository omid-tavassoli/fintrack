'use client'

import { useEffect, useState } from 'react'
import api from '@/lib/api'

// ── Types ──────────────────────────────────────────────────────────────────────
interface Budget {
  categoryName: string
  budgetAmount: number
  spentAmount: number
  percentageUsed: number
  status: 'GREEN' | 'AMBER' | 'RED'
}

interface Category { id: number; name: string }

// ── Helpers ────────────────────────────────────────────────────────────────────
const BAR_COLOR  = { GREEN: 'bg-green-500', AMBER: 'bg-amber-400', RED: 'bg-red-400' }
const TEXT_COLOR = { GREEN: 'text-green-400', AMBER: 'text-amber-400', RED: 'text-red-400' }

const currentMonth = new Date().toISOString().slice(0, 7)
const currentMonthLabel = new Date().toLocaleDateString('en-GB', { month: 'long', year: 'numeric' })

// ── Page ───────────────────────────────────────────────────────────────────────
export default function BudgetsPage() {
  const [budgets, setBudgets]         = useState<Budget[]>([])
  const [categories, setCategories]   = useState<Category[]>([])
  const [formCategory, setFormCategory] = useState('')
  const [formLimit, setFormLimit]     = useState('')
  const [formMonth, setFormMonth]     = useState(currentMonth)
  const [saving, setSaving]           = useState(false)
  const [saved, setSaved]             = useState(false)
  const [saveError, setSaveError]     = useState('')
  const [loading, setLoading]         = useState(true)

useEffect(() => {
  async function load() {
    try {
      const catsRes = await api.get('/api/categories')
      setCategories(catsRes.data)
      setFormCategory(catsRes.data[0]?.name ?? '')
    } catch (err) {
      console.error('Failed to load categories:', err)
    }

    try {
      const budgetsRes = await api.get('/api/analytics/budgets')
      setBudgets(budgetsRes.data)
    } catch {
      // no budgets yet — that's fine, show empty state
      setBudgets([])
    } finally {
      setLoading(false)
    }
  }
  load()
}, [])

  async function handleSubmit(e: React.FormEvent) {
    e.preventDefault()
    if (!formLimit || !formCategory) return

    setSaving(true)
    setSaveError('')

    try {
      await api.post('/api/budgets', {
        categoryName: formCategory,
        amount: parseFloat(formLimit),
        month: formMonth,
      })

      // refetch budgets to show updated state
      const res = await api.get('/api/analytics/budgets')
      setBudgets(res.data)

      setFormLimit('')
      setFormMonth(currentMonth)
      setSaved(true)
      setTimeout(() => setSaved(false), 2500)

    } catch (err: unknown) {
      const msg =
        err && typeof err === 'object' && 'response' in err
          ? (err as { response?: { data?: { message?: string; error?: string } } })
              .response?.data?.message ??
            (err as { response?: { data?: { message?: string; error?: string } } })
              .response?.data?.error
          : undefined
      setSaveError(msg || 'Failed to save budget. Please try again.')
    } finally {
      setSaving(false)
    }
  }

  return (
    <div className="grid gap-5 p-4 md:gap-6 md:p-6 lg:p-8">

      {/* Header */}
      <div className="grid gap-1">
        <h1 className="text-4xl font-black tracking-tight text-white">Budgets</h1>
        <p className="text-gray-500 font-mono text-sm">// {currentMonthLabel} · monthly limits</p>
      </div>

      <div className="grid grid-cols-1 gap-5 lg:grid-cols-[3fr_2fr]">

        {/* Current month progress */}
        <div className="grid gap-5 bg-[#111] rounded-2xl border border-[#2a2a2a] p-5 lg:p-6">
          <span className="text-gray-600 font-mono text-xs uppercase tracking-widest">Current Month</span>

          {loading ? (
            <p className="text-gray-600 font-mono text-sm">Loading...</p>
          ) : budgets.length === 0 ? (
            <div className="grid gap-2">
              <p className="text-gray-600 font-mono text-sm">No budgets set yet.</p>
              <p className="text-gray-700 font-mono text-xs">
                Set a budget for a category using the form on the right.
              </p>
            </div>
          ) : (
            <div className="grid gap-5">
              {budgets.map(b => (
                <div key={b.categoryName} className="grid gap-2">
                  <div className="flex items-center justify-between">
                    <span className="text-white text-sm font-medium">{b.categoryName}</span>
                    <span className="font-mono text-sm">
                      <span className={TEXT_COLOR[b.status]}>
                        €{b.spentAmount.toLocaleString('de-DE', { minimumFractionDigits: 2 })}
                      </span>
                      <span className="text-gray-600">
                        {' '}/ €{b.budgetAmount.toLocaleString('de-DE', { minimumFractionDigits: 2 })}
                      </span>
                    </span>
                  </div>
                  <div className="h-1.5 bg-[#1e1e1e] rounded-full overflow-hidden">
                    <div
                      className={`h-full rounded-full transition-all duration-700 ${BAR_COLOR[b.status]}`}
                      style={{ width: `${Math.min(b.percentageUsed, 100)}%` }}
                    />
                  </div>
                  <div className="flex justify-between">
                    <span className={`font-mono text-xs ${TEXT_COLOR[b.status]}`}>
                      {b.percentageUsed.toFixed(1)}% used
                    </span>
                    {b.status === 'RED' && (
                      <span className="text-red-400 font-mono text-xs">over budget</span>
                    )}
                  </div>
                </div>
              ))}
            </div>
          )}
        </div>

        {/* Add budget form */}
        <div className="grid gap-5 bg-[#111] rounded-2xl border border-[#2a2a2a] p-5 lg:p-6 content-start">
          <span className="text-gray-600 font-mono text-xs uppercase tracking-widest">Add Budget</span>

          <form onSubmit={handleSubmit} className="grid gap-4">

            <div className="grid gap-2">
              <label className="text-xs font-bold text-white uppercase tracking-widest font-mono">
                Category
              </label>
              <select
                value={formCategory}
                onChange={e => setFormCategory(e.target.value)}
                disabled={categories.length === 0}
                className="bg-[#1a1a1a] border border-[#2a2a2a] rounded-xl px-4 py-3 text-white text-sm outline-none focus:ring-2 focus:ring-green-700 transition-all appearance-none cursor-pointer disabled:opacity-50"
              >
                {categories.map(c => (
                  <option key={c.id} value={c.name}>{c.name}</option>
                ))}
              </select>
            </div>

            <div className="grid gap-2">
              <label className="text-xs font-bold text-white uppercase tracking-widest font-mono">
                Monthly Limit (€)
              </label>
              <input
                type="number"
                min="1"
                step="0.01"
                placeholder="200"
                value={formLimit}
                onChange={e => setFormLimit(e.target.value)}
                required
                className="bg-[#1a1a1a] border border-[#2a2a2a] rounded-xl px-4 py-3 text-white text-sm outline-none focus:ring-2 focus:ring-green-700 transition-all [appearance:textfield] [&::-webkit-outer-spin-button]:appearance-none [&::-webkit-inner-spin-button]:appearance-none"
              />
            </div>

            <div className="grid gap-2">
              <label className="text-xs font-bold text-white uppercase tracking-widest font-mono">
                Month
              </label>
              <input
                type="month"
                value={formMonth}
                onChange={e => setFormMonth(e.target.value)}
                required
                className="bg-[#1a1a1a] border border-[#2a2a2a] rounded-xl px-4 py-3 text-white text-sm outline-none focus:ring-2 focus:ring-green-700 transition-all [color-scheme:dark]"
              />
            </div>

            {saveError && (
              <p className="text-red-400 font-mono text-xs">{saveError}</p>
            )}

            <button
              type="submit"
              disabled={saving || categories.length === 0}
              className="w-full py-3.5 rounded-full bg-green-500 text-black font-semibold text-base hover:bg-green-400 active:bg-green-600 transition-colors disabled:opacity-50 mt-1"
            >
              {saved ? '✓ Saved' : saving ? 'Saving...' : 'Set Budget'}
            </button>

          </form>
        </div>

      </div>
    </div>
  )
}
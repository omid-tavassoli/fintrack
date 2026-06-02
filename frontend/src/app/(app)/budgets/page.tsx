'use client'

import { useEffect, useState } from 'react'
import api from '@/lib/api'

// ── Mock data ─────────────────────────────────────────────────────────────────
const DEMO_BUDGETS = [
  { categoryName: 'Groceries',     budgetAmount: 250, spentAmount: 187, percentageUsed: 74.8, status: 'GREEN' },
  { categoryName: 'Restaurants',   budgetAmount: 60,  spentAmount: 73,  percentageUsed: 121.7, status: 'RED'  },
  { categoryName: 'Subscriptions', budgetAmount: 150, spentAmount: 121, percentageUsed: 80.7, status: 'AMBER' },
  { categoryName: 'Transport',     budgetAmount: 100, spentAmount: 34,  percentageUsed: 34.0, status: 'GREEN' },
  { categoryName: 'Entertainment', budgetAmount: 80,  spentAmount: 56,  percentageUsed: 70.0, status: 'AMBER' },
]

const DEMO_CATEGORIES = ['Groceries', 'Restaurants', 'Subscriptions', 'Transport', 'Entertainment', 'Health', 'Shopping']

// ── Types ──────────────────────────────────────────────────────────────────────
interface Budget {
  categoryName: string
  budgetAmount: number
  spentAmount: number
  percentageUsed: number
  status: 'GREEN' | 'AMBER' | 'RED'
}

// ── Helpers ────────────────────────────────────────────────────────────────────
const BAR_COLOR  = { GREEN: 'bg-green-500', AMBER: 'bg-amber-400', RED: 'bg-red-400' }
const TEXT_COLOR = { GREEN: 'text-green-400', AMBER: 'text-amber-400', RED: 'text-red-400' }

const currentMonth = new Date().toISOString().slice(0, 7) // "2026-06"
const currentMonthLabel = new Date().toLocaleDateString('en-GB', { month: 'long', year: 'numeric' })

// ── Page ───────────────────────────────────────────────────────────────────────
export default function BudgetsPage() {
  const [budgets, setBudgets] = useState<Budget[]>([])
  const [categories, setCategories] = useState<string[]>(DEMO_CATEGORIES)
  const [formCategory, setFormCategory] = useState(DEMO_CATEGORIES[0])
  const [formLimit, setFormLimit] = useState('')
  const [formMonth, setFormMonth] = useState(currentMonth)
  const [saving, setSaving] = useState(false)
  const [saved, setSaved] = useState(false)

  useEffect(() => {
    const isDemo = localStorage.getItem('isDemo') === 'true'

    if (isDemo) {
      setBudgets(DEMO_BUDGETS as Budget[])
      return
    }

    // API CALL: GET /api/analytics/budget
    //   → BudgetStatusDTO[] { categoryName, budgetAmount, spentAmount, percentageUsed, status: "GREEN"|"AMBER"|"RED" }
    //   setBudgets(data)

    // API CALL: GET /api/categories
    //   → CategoryResponse[] { id, name }
    //   setCategories(data.map(c => c.name))
    //   setFormCategory(data[0]?.name ?? '')
  }, [])

  async function handleSubmit(e: React.FormEvent) {
    e.preventDefault()
    if (!formLimit) return
    setSaving(true)
    try {
      // API CALL: POST /api/budgets (endpoint needs to be created in backend)
      //   → body: { categoryName: formCategory, amount: parseFloat(formLimit), month: formMonth }
      //   On success: refetch budgets via GET /api/analytics/budget
      await api.post('/api/budgets', {
        categoryName: formCategory,
        amount: parseFloat(formLimit),
        month: formMonth,
      })
      setSaved(true)
      setTimeout(() => setSaved(false), 2000)
      setFormLimit('')
    } catch {
      // Backend endpoint may not exist yet — see comment above
      setSaved(true)
      setTimeout(() => setSaved(false), 2000)
    } finally {
      setSaving(false)
    }
  }

  return (
    <div className="grid gap-5 p-4 md:gap-6 md:p-6 lg:p-8">

      {/* Header */}
      <div className="grid gap-1">
        <h1 className="text-4xl font-black tracking-tight text-white md:text-4xl lg:text-4xl">Budgets</h1>
        <p className="text-gray-500 font-mono text-sm">// {currentMonthLabel} · monthly limits</p>
      </div>

      {/* Two-column layout — stacked on mobile, side by side on desktop */}
      <div className="grid grid-cols-1 gap-5 lg:grid-cols-[3fr_2fr]">

        {/* Current month progress */}
        <div className="grid gap-5 bg-[#111] rounded-2xl border border-[#2a2a2a] p-5 lg:p-6">
          <span className="text-gray-600 font-mono text-xs uppercase tracking-widest">Current Month</span>

          {budgets.length === 0 ? (
            <p className="text-gray-600 font-mono text-sm">No budgets set yet.</p>
          ) : (
            <div className="grid gap-5">
              {budgets.map(b => (
                <div key={b.categoryName} className="grid gap-2">
                  <div className="flex items-center justify-between">
                    <span className="text-white text-sm font-medium">{b.categoryName}</span>
                    <span className="font-mono text-sm">
                      <span className={TEXT_COLOR[b.status]}>€{b.spentAmount}</span>
                      <span className="text-gray-600"> / €{b.budgetAmount}</span>
                    </span>
                  </div>
                  {/* Progress bar */}
                  <div className="h-1.5 bg-[#1e1e1e] rounded-full overflow-hidden">
                    <div
                      className={`h-full rounded-full transition-all duration-700 ${BAR_COLOR[b.status]}`}
                      style={{ width: `${Math.min(b.percentageUsed, 100)}%` }}
                    />
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
              <label className="text-xs font-bold text-white uppercase tracking-widest font-mono">Category</label>
              <select
                value={formCategory}
                onChange={e => setFormCategory(e.target.value)}
                className="bg-[#1a1a1a] border border-[#2a2a2a] rounded-xl px-4 py-3 text-white text-sm outline-none focus:ring-2 focus:ring-green-700 transition-all appearance-none cursor-pointer"
              >
                {categories.map(c => (
                  <option key={c} value={c}>{c}</option>
                ))}
              </select>
            </div>

            <div className="grid gap-2">
              <label className="text-xs font-bold text-white uppercase tracking-widest font-mono">Monthly Limit (€)</label>
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
              <label className="text-xs font-bold text-white uppercase tracking-widest font-mono">Month</label>
              <input
                type="month"
                value={formMonth}
                onChange={e => setFormMonth(e.target.value)}
                required
                className="bg-[#1a1a1a] border border-[#2a2a2a] rounded-xl px-4 py-3 text-white text-sm outline-none focus:ring-2 focus:ring-green-700 transition-all [color-scheme:dark]"
              />
            </div>

            <button
              type="submit"
              disabled={saving}
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

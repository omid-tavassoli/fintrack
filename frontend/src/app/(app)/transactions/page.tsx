'use client'

import { useEffect, useMemo, useState } from 'react'

// ── Mock data (used when isDemo=true) ─────────────────────────────────────────
const DEMO_TRANSACTIONS = [
  { id: 1,  description: 'Bantschow Services GmbH · LOHN',      counterpart: 'Bantschow Services', amount:  1247.73, transactionDate: '2025-10-29', categoryName: 'Transfers',   categoryId: 1, isAnomaly: false, geminiUsed: false },
  { id: 2,  description: 'SEPA Überweisung Klaus Lemke · Miete', counterpart: 'Klaus Lemke',        amount:  -600.00, transactionDate: '2025-10-29', categoryName: 'Transfers',   categoryId: 1, isAnomaly: false, geminiUsed: true  },
  { id: 3,  description: 'SumUp Mr. Masala Munster',             counterpart: 'Mr. Masala',         amount:   -11.90, transactionDate: '2025-10-27', categoryName: 'Restaurants', categoryId: 2, isAnomaly: false, geminiUsed: true  },
  { id: 4,  description: 'Techniker Krankenkasse · Beitraege',   counterpart: 'TK',                 amount:  -144.24, transactionDate: '2025-10-15', categoryName: 'Health',      categoryId: 3, isAnomaly: true,  geminiUsed: false },
  { id: 5,  description: 'Restaurant Hani Frankfurt',            counterpart: 'Restaurant Hani',    amount:   -41.00, transactionDate: '2025-10-13', categoryName: 'Restaurants', categoryId: 2, isAnomaly: true,  geminiUsed: true  },
  { id: 6,  description: 'REWE Ahmet Akay Frankfurt',            counterpart: 'REWE',               amount:   -15.16, transactionDate: '2025-10-10', categoryName: 'Groceries',   categoryId: 4, isAnomaly: false, geminiUsed: false },
  { id: 7,  description: 'MVG Monatskarte Oktober',              counterpart: 'MVG München',        amount:   -57.80, transactionDate: '2025-10-05', categoryName: 'Transport',   categoryId: 5, isAnomaly: false, geminiUsed: true  },
  { id: 8,  description: 'Spotify Premium',                      counterpart: 'Spotify AB',         amount:   -10.99, transactionDate: '2025-10-01', categoryName: 'Subscriptions', categoryId: 6, isAnomaly: false, geminiUsed: false },
  { id: 9,  description: 'ZARA Frankfurt Börsenstraße',          counterpart: 'ZARA',               amount:   -30.10, transactionDate: '2025-09-28', categoryName: 'Shopping',    categoryId: 7, isAnomaly: true,  geminiUsed: true  },
  { id: 10, description: 'EDEKA Center Frankfurt',               counterpart: 'EDEKA',              amount:   -42.30, transactionDate: '2025-09-25', categoryName: 'Groceries',   categoryId: 4, isAnomaly: false, geminiUsed: false },
]

// ── Types ──────────────────────────────────────────────────────────────────────
interface Transaction {
  id: number
  description: string
  counterpart: string
  amount: number
  transactionDate: string
  categoryName: string
  categoryId: number
  isAnomaly: boolean
  geminiUsed: boolean
}

// ── Helpers ────────────────────────────────────────────────────────────────────
// Deterministic color per category name (maps to one of 6 palettes)
const PALETTES = [
  'bg-green-500/15 text-green-400 border-green-500/20',
  'bg-amber-500/15 text-amber-400 border-amber-500/20',
  'bg-blue-500/15 text-blue-400 border-blue-500/20',
  'bg-purple-500/15 text-purple-400 border-purple-500/20',
  'bg-rose-500/15 text-rose-400 border-rose-500/20',
  'bg-sky-500/15 text-sky-400 border-sky-500/20',
]

function catColor(name: string) {
  let hash = 0
  for (let i = 0; i < name.length; i++) hash = name.charCodeAt(i) + ((hash << 5) - hash)
  return PALETTES[Math.abs(hash) % PALETTES.length]
}

function fmtAmount(v: number) {
  const abs = new Intl.NumberFormat('de-DE', { minimumFractionDigits: 2, maximumFractionDigits: 2 }).format(Math.abs(v))
  return v >= 0 ? `+€${abs}` : `-€${abs}`
}

// ── Sub-components ─────────────────────────────────────────────────────────────
function CategoryBadge({ name }: { name: string }) {
  // TODO: Make this clickable to trigger PATCH /api/transactions/{id}/category
  //       Needs a category picker dropdown (GET /api/categories for the list)
  return (
    <span className={`inline-block px-2.5 py-0.5 rounded-md text-xs font-medium border ${catColor(name)}`}>
      {name}
    </span>
  )
}

function AiBadge({ geminiUsed }: { geminiUsed: boolean }) {
  if (geminiUsed) return <span className="text-xs font-mono text-teal-400">gemini</span>
  return <span className="text-xs font-mono text-gray-600 bg-[#1e1e1e] px-2 py-0.5 rounded-md">rule</span>
}

function WarnIcon() {
  return (
    <svg width="12" height="12" viewBox="0 0 16 15" fill="none" className="shrink-0">
      <path d="M8 1L1 14h14L8 1z" stroke="#fbbf24" strokeWidth="1.2" strokeLinejoin="round" fill="#fbbf24" fillOpacity="0.12" />
      <path d="M8 5.5v4" stroke="#fbbf24" strokeWidth="1.4" strokeLinecap="round" />
      <circle cx="8" cy="11.5" r="0.8" fill="#fbbf24" />
    </svg>
  )
}

// ── Page ───────────────────────────────────────────────────────────────────────
export default function TransactionsPage() {
  const [transactions, setTransactions] = useState<Transaction[]>([])
  const [search, setSearch] = useState('')
  const [activeFilter, setActiveFilter] = useState<string>('all')

  useEffect(() => {
    const isDemo = localStorage.getItem('isDemo') === 'true'

    if (isDemo) {
      setTransactions(DEMO_TRANSACTIONS)
      return
    }

    // API CALL: GET /api/transactions
    //   → TransactionResponse[] { id, description, counterpart, amount, transactionDate,
    //                             categoryName, categoryId, isAnomaly, geminiUsed }
    //   setTransactions(data)
  }, [])

  // Derive stats from the full list (before filters)
  const total        = transactions.length
  const categorized  = transactions.filter(t => t.categoryName).length
  const uncategorized = total - categorized

  // Top 3 categories by frequency → shown as quick-filter pills
  const topCategories = useMemo(() => {
    const freq: Record<string, number> = {}
    transactions.forEach(t => { if (t.categoryName) freq[t.categoryName] = (freq[t.categoryName] ?? 0) + 1 })
    return Object.entries(freq).sort((a, b) => b[1] - a[1]).slice(0, 3).map(([name]) => name)
  }, [transactions])

  // Apply search + active filter
  const filtered = useMemo(() => {
    let list = transactions
    if (search.trim()) {
      const q = search.toLowerCase()
      list = list.filter(t =>
        t.description.toLowerCase().includes(q) ||
        t.counterpart.toLowerCase().includes(q)
      )
    }
    if (activeFilter === 'anomalies') list = list.filter(t => t.isAnomaly)
    else if (activeFilter !== 'all') list = list.filter(t => t.categoryName === activeFilter)
    return list
  }, [transactions, search, activeFilter])

  return (
    <div className="grid gap-5 p-4 md:gap-6 md:p-6 lg:p-8">

      {/* Header */}
      <div className="grid gap-1">
        <h1 className="text-4xl font-black tracking-tight text-white md:text-4xl lg:text-4xl">Transactions</h1>
        <p className="text-gray-500 font-mono text-sm">
          // {total} total · {categorized} categorized · {uncategorized} uncategorized
        </p>
      </div>

      {/* Filter bar — search + category pills */}
      <div className="flex flex-wrap items-center gap-3">

        {/* Search */}
        <input
          type="text"
          placeholder="Search transactions..."
          value={search}
          onChange={e => setSearch(e.target.value)}
          className="flex-1 min-w-[200px] bg-[#111] border border-[#2a2a2a] rounded-xl px-4 py-2.5 text-white text-sm placeholder-gray-600 outline-none focus:ring-2 focus:ring-green-700 transition-all font-mono"
        />

        {/* Filter pills */}
        <div className="flex items-center gap-2 flex-wrap">
          {['all', ...topCategories, 'anomalies'].map(f => {
            const active = activeFilter === f
            const label = f === 'all' ? 'All' : f === 'anomalies' ? '⚠ Anomalies' : f
            return (
              <button
                key={f}
                onClick={() => setActiveFilter(f)}
                className={`px-4 py-2 rounded-xl text-sm font-medium border transition-colors ${
                  active
                    ? 'border-green-500 text-green-400 bg-green-500/10'
                    : 'border-[#2a2a2a] text-gray-500 hover:text-white hover:border-[#444]'
                }`}
              >
                {label}
              </button>
            )
          })}
        </div>
      </div>

      {/* Table */}
      <div className="bg-[#111] rounded-2xl border border-[#2a2a2a] overflow-hidden">
        <div className="overflow-x-auto">
          <table className="w-full min-w-[680px]">
            <thead>
              <tr className="border-b border-[#1e1e1e]">
                {['Date', 'Description', 'Counterpart', 'Category', 'Amount', 'AI'].map(col => (
                  <th
                    key={col}
                    className="px-5 py-4 text-left text-xs font-semibold text-gray-600 uppercase tracking-widest font-mono"
                  >
                    {col}
                  </th>
                ))}
              </tr>
            </thead>
            <tbody>
              {filtered.length === 0 ? (
                <tr>
                  <td colSpan={6} className="px-5 py-10 text-center text-gray-600 font-mono text-sm">
                    no transactions found
                  </td>
                </tr>
              ) : (
                filtered.map(t => (
                  <tr
                    key={t.id}
                    className="border-b border-[#1a1a1a] last:border-0 hover:bg-[#131313] transition-colors"
                  >
                    {/* Date */}
                    <td className="px-5 py-4 text-gray-500 font-mono text-sm whitespace-nowrap">
                      {t.transactionDate}
                    </td>

                    {/* Description */}
                    <td className="px-5 py-4 text-white text-sm max-w-[220px]">
                      <span className="truncate block">{t.description}</span>
                    </td>

                    {/* Counterpart */}
                    <td className="px-5 py-4 text-gray-400 text-sm whitespace-nowrap">
                      {t.counterpart}
                    </td>

                    {/* Category */}
                    <td className="px-5 py-4">
                      <CategoryBadge name={t.categoryName || 'Uncategorized'} />
                    </td>

                    {/* Amount */}
                    <td className="px-5 py-4 whitespace-nowrap">
                      <div className="flex items-center gap-1.5">
                        <span className={`font-mono text-sm font-medium tabular-nums ${t.amount >= 0 ? 'text-green-400' : 'text-red-400'}`}>
                          {fmtAmount(t.amount)}
                        </span>
                        {t.isAnomaly && <WarnIcon />}
                      </div>
                    </td>

                    {/* AI */}
                    <td className="px-5 py-4">
                      <AiBadge geminiUsed={t.geminiUsed} />
                    </td>
                  </tr>
                ))
              )}
            </tbody>
          </table>
        </div>
      </div>

    </div>
  )
}

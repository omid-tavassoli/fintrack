'use client'

import api from '@/lib/api'
import { useEffect, useMemo, useState } from 'react'

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

interface Category { id: number; name: string }

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

// ── Edit Modal ─────────────────────────────────────────────────────────────────
function EditModal({
  tx, categories, onClose, onSave,
}: {
  tx: Transaction
  categories: Category[]
  onClose: () => void
  onSave: (txId: number, categoryId: number, categoryName: string) => void
}) {
  const [selectedId, setSelectedId] = useState(tx.categoryId)
  const [saving, setSaving] = useState(false)

  async function handleSave() {
    setSaving(true)
    try {
      // API CALL: PATCH /api/transactions/{id}/category
      // → body: { categoryId }
      // → TransactionResponse with updated category
      await api.patch(`/api/transactions/${tx.id}/category`, { categoryId: selectedId })
      const cat = categories.find(c => c.id === selectedId)
      onSave(tx.id, selectedId, cat?.name ?? '')
      onClose()
    } catch {
      // request failed — still update UI optimistically
      const cat = categories.find(c => c.id === selectedId)
      onSave(tx.id, selectedId, cat?.name ?? '')
      onClose()
    } finally {
      setSaving(false)
    }
  }

  return (
    <div className="fixed inset-0 z-50 grid place-items-center bg-black/70 p-4" onClick={onClose}>
      <div
        className="bg-[#111] border border-[#2a2a2a] rounded-2xl w-full max-w-md p-6 grid gap-5 shadow-2xl"
        onClick={e => e.stopPropagation()}
      >
        {/* Header */}
        <div className="flex items-start justify-between gap-4">
          <div className="grid gap-1">
            <h2 className="text-white font-bold text-lg leading-tight">{tx.counterpart || 'Transaction'}</h2>
            <p className="text-gray-500 font-mono text-xs">{tx.transactionDate}</p>
          </div>
          <button onClick={onClose} className="text-gray-600 hover:text-white text-xl leading-none mt-0.5">×</button>
        </div>

        {/* Details */}
        <div className="grid gap-3 bg-[#0e0e0e] rounded-xl p-4">
          <Row label="Amount"      value={<span className={tx.amount >= 0 ? 'text-green-400' : 'text-red-400'}>{fmtAmount(tx.amount)}</span>} />
          <Row label="Description" value={<span className="text-gray-300 text-xs leading-relaxed">{tx.description}</span>} />
          <Row label="Counterpart" value={tx.counterpart} />
          <Row label="AI Method"   value={<AiBadge geminiUsed={tx.geminiUsed} />} />
          {tx.isAnomaly && <Row label="Anomaly" value={<span className="text-amber-400 font-mono text-xs">⚠ flagged</span>} />}
        </div>

        {/* Category picker */}
        <div className="grid gap-2">
          <label className="text-xs font-bold text-white uppercase tracking-widest font-mono">Change Category</label>
          <select
            value={selectedId}
            onChange={e => setSelectedId(Number(e.target.value))}
            className="bg-[#1a1a1a] border border-[#2a2a2a] rounded-xl px-4 py-3 text-white text-sm outline-none focus:ring-2 focus:ring-green-700 appearance-none cursor-pointer"
          >
            {categories.map(c => (
              <option key={c.id} value={c.id}>{c.name}</option>
            ))}
          </select>
        </div>

        {/* Actions */}
        <div className="flex gap-3">
          <button
            onClick={onClose}
            className="flex-1 py-3 rounded-xl border border-[#2a2a2a] text-gray-400 text-sm font-medium hover:border-[#444] transition-colors"
          >
            Cancel
          </button>
          <button
            onClick={handleSave}
            disabled={saving}
            className="flex-1 py-3 rounded-xl bg-green-500 text-black text-sm font-bold hover:bg-green-400 transition-colors disabled:opacity-50"
          >
            {saving ? 'Saving...' : 'Save'}
          </button>
        </div>
      </div>
    </div>
  )
}

function Row({ label, value }: { label: string; value: React.ReactNode }) {
  return (
    <div className="flex items-start justify-between gap-4">
      <span className="text-gray-600 font-mono text-xs shrink-0 pt-0.5">{label}</span>
      <span className="text-white text-sm text-right">{value}</span>
    </div>
  )
}

function formatMonth(m: string) {
  const [y, mo] = m.split('-')
  return new Date(parseInt(y), parseInt(mo) - 1).toLocaleDateString('en-GB', { month: 'short', year: 'numeric' })
}

// ── Page ───────────────────────────────────────────────────────────────────────
export default function TransactionsPage() {
  const [transactions, setTransactions] = useState<Transaction[]>([])
  const [categories, setCategories] = useState<Category[]>([])
  const [query, setQuery] = useState('')
  const [selectedMonth, setSelectedMonth] = useState<string | null>(null)
  const [activeFilter, setActiveFilter] = useState<string>('all')
  const [sortBy, setSortBy] = useState<string>('date')
  const [editTx, setEditTx] = useState<Transaction | null>(null)
  const [isDemo, setIsDemo] = useState(false)

  useEffect(() => {
    Promise.all([
      api.get('/api/transactions'),
      api.get('/api/categories'),
    ]).then(([txRes, catRes]) => {
      setTransactions(txRes.data)
      setCategories(catRes.data)
    }).catch(console.error)
  }, [])

  useEffect(() => {
  const email = localStorage.getItem('userEmail')
  setIsDemo(email === 'demo@fintrack.com')
}, [])

  // Stats (always from full list)
  const total         = transactions.length
  const categorized   = transactions.filter(t => t.categoryName).length
  const uncategorized = total - categorized
  const geminiCalls   = transactions.filter(t => t.geminiUsed).length

  // Unique months from data, newest first
  const months = useMemo(() =>
    Array.from(new Set(transactions.map(t => t.transactionDate.slice(0, 7)))).sort().reverse()
  , [transactions])

  // Apply month filter first — everything else derives from this
  const monthFiltered = useMemo(() => {
    if (!selectedMonth) return transactions
    return transactions.filter(t => t.transactionDate.startsWith(selectedMonth))
  }, [transactions, selectedMonth])

  // Fixed category filter list
  const CATEGORY_FILTERS = [
    'Transfers', 'Transport', 'Health', 'Shopping', 'Rent & Utilities',
    'Entertainment', 'Donations', 'University',
  ]

  // Category + AI filter → then text search within that result → then sort
  const filtered = useMemo(() => {
    // 1. Category / anomaly / AI filter
    let list = monthFiltered
    if      (activeFilter === 'anomalies') list = list.filter(t => t.isAnomaly)
    else if (activeFilter !== 'all')       list = list.filter(t => t.categoryName?.toLowerCase() === activeFilter.toLowerCase())
    if (sortBy === 'ai') list = list.filter(t => t.geminiUsed)

    // 2. Text search within the already-filtered list
    if (query.trim()) {
      const q = query.toLowerCase()
      list = list.filter(t =>
        t.description.toLowerCase().includes(q) ||
        t.counterpart.toLowerCase().includes(q)
      )
    }

    // 3. Sort
    const sorted = [...list]
    if (sortBy === 'amount-asc')
      sorted.sort((a, b) => {
        const diff = Math.abs(a.amount) - Math.abs(b.amount)
        return diff !== 0 ? diff : a.amount - b.amount // tie: negative first
      })
    else if (sortBy === 'amount-desc')
      sorted.sort((a, b) => {
        const diff = Math.abs(b.amount) - Math.abs(a.amount)
        return diff !== 0 ? diff : a.amount - b.amount // tie: negative first
      })
    else if (sortBy === 'date')        sorted.sort((a, b) => a.transactionDate.localeCompare(b.transactionDate))
    return sorted
  }, [monthFiltered, query, activeFilter, sortBy])

  // Category override callback
  function handleCategoryUpdate(txId: number, categoryId: number, categoryName: string) {
    setTransactions(prev =>
      prev.map(t => t.id === txId ? { ...t, categoryId, categoryName } : t)
    )
  }

  return (
    <>
      {/* Edit Modal */}
      {editTx && (
        <EditModal
          tx={editTx}
          categories={categories}
          onClose={() => setEditTx(null)}
          onSave={handleCategoryUpdate}
        />
      )}

      <div className="grid gap-5 p-4 md:gap-6 md:p-6 lg:p-8">

        {/* Header */}
        <div className="grid gap-1">
          <h1 className="text-4xl font-black tracking-tight text-white">Transactions</h1>
        <p className="text-gray-500 font-mono text-sm">
          // browse, search, and edit your transactions
        </p>
        </div>

        {/* Stats row */}
        <div className="grid grid-cols-2 gap-3 lg:grid-cols-4">
          {[
            { label: 'Imported',      value: total,         color: 'text-white'      },
            { label: 'Categorized',   value: categorized,   color: 'text-green-400'  },
            { label: 'Uncategorized', value: uncategorized, color: 'text-amber-400'  },
            { label: 'AI Calls',  value: geminiCalls,   color: 'text-teal-400'   },
          ].map(s => (
            <div key={s.label} className="bg-[#111] rounded-xl border border-[#2a2a2a] p-4 grid gap-1">
              <span className="text-gray-600 font-mono text-xs uppercase tracking-widest">{s.label}</span>
              <span className={`font-mono text-2xl font-bold ${s.color}`}>{s.value}</span>
            </div>
          ))}
          
        </div>

        {/* Search */}
        <input
          type="text"
          placeholder="Search transactions..."
          value={query}
          onChange={e => setQuery(e.target.value)}
          className="w-full bg-[#111] border border-[#2a2a2a] rounded-xl px-4 py-2.5 text-white text-sm placeholder-gray-600 outline-none focus:ring-2 focus:ring-green-700 transition-all font-mono"
        />
        {isDemo && (
              <div className="bg-[#0e1a10] border border-green-900/30 rounded-xl px-5 py-4 flex items-start gap-3">
                <span className="text-green-600 text-lg shrink-0 mt-0.5">🔒</span>
                <div className="grid gap-1">
                  <p className="text-green-400 font-mono text-xs font-semibold uppercase tracking-widest">
                    Datenschutzhinweis
                  </p>
                  <p className="text-gray-400 text-sm leading-relaxed">
                    Gemäß{' '}
                    <span className="text-white font-medium">DSGVO Art. 4 Nr. 1</span>
                    {' '}wurden in diesem Demo-Konto personenbezogene Daten anonymisiert: 
                    Echte Namen wurden durch generische Bezeichnungen ersetzt, IBANs und 
                    Kartennummern wurden entfernt, und persönliche Referenznummern wurden 
                    geschwärzt. Transaktionsbeträge und Händlernamen spiegeln reale 
                    Ausgabemuster wider.
                  </p>
                </div>
              </div>
            )}

        {/* Filters — month row + category row */}
        <div className="grid gap-3">

          {/* Month filter */}
          <div className="flex items-center gap-3 flex-wrap">
            <span className="text-gray-600 font-mono text-xs uppercase tracking-widest w-16 shrink-0">Month</span>
            <div className="flex gap-2 flex-wrap">
              <button
                onClick={() => { setSelectedMonth(null); setActiveFilter('all') }}
                className={`px-3 py-1.5 rounded-lg text-xs font-medium border transition-colors ${
                  !selectedMonth ? 'border-green-500 text-green-400 bg-green-500/10' : 'border-[#2a2a2a] text-gray-500 hover:text-white hover:border-[#444]'
                }`}
              >
                All
              </button>
              {months.map(m => (
                <button
                  key={m}
                  onClick={() => { setSelectedMonth(m); setActiveFilter('all') }}
                  className={`px-3 py-1.5 rounded-lg text-xs font-medium border transition-colors font-mono ${
                    selectedMonth === m ? 'border-green-500 text-green-400 bg-green-500/10' : 'border-[#2a2a2a] text-gray-500 hover:text-white hover:border-[#444]'
                  }`}
                >
                  {formatMonth(m)}
                </button>
              ))}
            </div>
          </div>

          {/* Category filter — dropdown on mobile, pills on md+ */}
          <div className="flex items-center gap-3">
            <span className="text-gray-600 font-mono text-xs uppercase tracking-widest w-16 shrink-0">Category</span>

            {/* Mobile: dropdown */}
            <select
              value={activeFilter}
              onChange={e => setActiveFilter(e.target.value)}
              className="md:hidden flex-1 bg-[#111] border border-[#2a2a2a] rounded-xl px-3 py-2 text-white text-sm outline-none focus:ring-2 focus:ring-green-700 appearance-none cursor-pointer [color-scheme:dark]"
            >
              {['all', ...CATEGORY_FILTERS, 'anomalies'].map(f => (
                <option key={f} value={f}>
                  {f === 'all' ? 'All' : f === 'anomalies' ? '⚠ Anomalies' : f}
                </option>
              ))}
            </select>

            {/* Desktop: pills */}
            <div className="hidden md:flex gap-2 flex-wrap">
              {['all', ...CATEGORY_FILTERS, 'anomalies'].map(f => {
                const active = activeFilter === f
                const label = f === 'all' ? 'All' : f === 'anomalies' ? '⚠ Anomalies' : f
                return (
                  <button
                    key={f}
                    onClick={() => setActiveFilter(f)}
                    className={`px-3 py-1.5 rounded-lg text-xs font-medium border transition-colors whitespace-nowrap ${
                      active ? 'border-green-500 text-green-400 bg-green-500/10' : 'border-[#2a2a2a] text-gray-500 hover:text-white hover:border-[#444]'
                    }`}
                  >
                    {label}
                  </button>
                )
              })}
            </div>
          </div>

          {/* Sort */}
          <div className="flex items-center gap-3 flex-wrap">
            <span className="text-gray-600 font-mono text-xs uppercase tracking-widest w-16 shrink-0">Sort</span>
            <div className="flex gap-2 flex-wrap">
              {[
                { key: 'date',        label: 'Date' },
                { key: 'amount-asc',  label: 'Amount ↑' },
                { key: 'amount-desc', label: 'Amount ↓' },
                { key: 'ai',          label: 'AI Categorized' },
              ].map(({ key, label }) => (
                <button
                  key={key}
                  onClick={() => setSortBy(key)}
                  className={`px-3 py-1.5 rounded-lg text-xs font-medium border transition-colors whitespace-nowrap ${
                    sortBy === key ? 'border-green-500 text-green-400 bg-green-500/10' : 'border-[#2a2a2a] text-gray-500 hover:text-white hover:border-[#444]'
                  }`}
                >
                  {label}
                </button>
              ))}
            </div>
          </div>

        </div>

        {/* Transaction cards — all screen sizes */}
        <div className="grid gap-3">
          {filtered.length === 0 ? (
            <p className="text-center text-gray-600 font-mono text-sm py-10">no transactions found</p>
          ) : filtered.map(t => (
            <div key={t.id} className="bg-[#111] border border-[#2a2a2a] rounded-2xl p-4 grid gap-3">
              <div className="flex items-center justify-between">
                <span className="text-gray-500 font-mono text-xs">
                  {t.transactionDate.split('-').reverse().join('/')}
                </span>
                <div className="flex items-center gap-1.5">
                  <span className={`font-mono text-sm font-semibold tabular-nums ${t.amount >= 0 ? 'text-green-400' : 'text-red-400'}`}>
                    {fmtAmount(t.amount)}
                  </span>
                  {t.isAnomaly && <WarnIcon />}
                </div>
              </div>
              <p className="text-white text-sm font-medium leading-snug">{t.description}</p>
              <div className="flex items-center justify-between gap-2 flex-wrap">
                <div className="flex items-center gap-2 flex-wrap">
                  <span className={`inline-block px-2 py-0.5 rounded-md text-xs font-medium border ${catColor(t.categoryName || 'Uncategorized')}`}>
                    {t.categoryName || 'Uncategorized'}
                  </span>
                  <span className="text-gray-600 text-xs">{t.counterpart}</span>
                  <AiBadge geminiUsed={t.geminiUsed} />
                </div>
                <button
                  onClick={() => setEditTx(t)}
                  className="px-3 py-1 rounded-lg border border-[#2a2a2a] text-gray-500 text-xs hover:border-green-500/50 hover:text-green-400 transition-colors font-mono shrink-0"
                >
                  edit
                </button>
              </div>
            </div>
          ))}
        </div>

      </div>
    </>
  )
}
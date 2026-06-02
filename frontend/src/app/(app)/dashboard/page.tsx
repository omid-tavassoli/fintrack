'use client'

import { useEffect, useState } from 'react'
import {
  BarChart, Bar, XAxis, Tooltip, ResponsiveContainer, LabelList,
  PieChart, Pie, Cell,
} from 'recharts'

// ── Mock data (used when isDemo=true in localStorage) ─────────────────────────
const DEMO_MONTHLY = [
  { month: 'Dec', amount: 1200 },
  { month: 'Jan', amount: 980  },
  { month: 'Feb', amount: 1400 },
  { month: 'Mar', amount: 1100 },
  { month: 'Apr', amount: 1700 },
  { month: 'May', amount: 1847 },
]

const DEMO_CATEGORIES = [
  { name: 'Rent',          value: 554, pct: 30 },
  { name: 'Groceries',     value: 369, pct: 20 },
  { name: 'Subscriptions', value: 277, pct: 15 },
  { name: 'Restaurants',   value: 185, pct: 10 },
  { name: 'Transport',     value: 148, pct:  8 },
]

const DEMO_ANOMALIES = [
  { transactionId: 1, description: 'Restaurant Hani — Frankfurt', amount: -41.00,  reason: '4.2x above average for Restaurants (avg: €12.50)' },
  { transactionId: 2, description: 'ZARA Frankfurt Börsenstraße',  amount: -30.10,  reason: '3.1x above average for Shopping (avg: €18.20)'   },
  { transactionId: 3, description: 'Techniker Krankenkasse',       amount: -144.24, reason: '2.8x above average for Health (avg: €52.00)'     },
]

// ── Types ──────────────────────────────────────────────────────────────────────
interface MonthlyPoint   { month: string; amount: number }
interface CategoryPoint  { name: string; value: number; pct: number }
interface AnomalyItem    { transactionId: number; description: string; amount: number; reason: string }
interface DashboardData  {
  totalSpent: number
  income: number
  anomalyCount: number
  aiAccuracy: number
  txCount: number
  currentMonth: string
  monthly: MonthlyPoint[]
  categories: CategoryPoint[]
  anomalies: AnomalyItem[]
}

// ── Helpers ────────────────────────────────────────────────────────────────────
const CAT_COLORS = ['#4ade80', '#22c55e', '#fbbf24', '#f87171', '#60a5fa']

function fmtK(v: unknown) {
  const n = v as number
  return n >= 1000 ? `€${(n / 1000).toFixed(1)}k` : `€${n}`
}

function fmtEuro(v: number) {
  return new Intl.NumberFormat('de-DE', { style: 'currency', currency: 'EUR' }).format(Math.abs(v))
}

// ── Sub-components ─────────────────────────────────────────────────────────────
function StatCard({ label, value, sub, color }: { label: string; value: string; sub: string; color: string }) {
  return (
    <div className="grid gap-3 bg-[#111] rounded-2xl border border-[#2a2a2a] p-5">
      <span className="text-gray-500 font-mono text-xs uppercase tracking-widest">{label}</span>
      <span className={`font-mono text-2xl font-bold leading-none md:text-3xl ${color}`}>{value}</span>
      <span className="text-gray-600 font-mono text-xs">{sub}</span>
    </div>
  )
}

function WarnIcon() {
  return (
    <svg width="16" height="15" viewBox="0 0 16 15" fill="none">
      <path d="M8 1L1 14h14L8 1z" stroke="#fbbf24" strokeWidth="1.2" strokeLinejoin="round" fill="#fbbf24" fillOpacity="0.12" />
      <path d="M8 5.5v4" stroke="#fbbf24" strokeWidth="1.4" strokeLinecap="round" />
      <circle cx="8" cy="11.5" r="0.8" fill="#fbbf24" />
    </svg>
  )
}

// ── Page ───────────────────────────────────────────────────────────────────────
export default function DashboardPage() {
  const [data, setData] = useState<DashboardData | null>(null)

  useEffect(() => {
    const isDemo = localStorage.getItem('isDemo') === 'true'

    if (isDemo) {
      setData({
        totalSpent:   1847,
        income:       1248,
        anomalyCount: DEMO_ANOMALIES.length,
        aiAccuracy:   98.4,
        txCount:      127,
        currentMonth: 'May 2026',
        monthly:      DEMO_MONTHLY,
        categories:   DEMO_CATEGORIES,
        anomalies:    DEMO_ANOMALIES,
      })
      return
    }

    // ── Wire up when ready ─────────────────────────────────────────────────────
    // All endpoints need Bearer token — auto-attached by src/lib/api.ts

    // API CALL: GET /api/analytics/monthly
    //   → MonthlySpendingDTO[] { month: "YYYY-MM", total: number, byCategory: Record<string,number> }
    //   Map: last 6 entries, format "YYYY-MM" → "Jan" for X axis, use `total` as `amount`

    // API CALL: GET /api/analytics/categories?month=YYYY-MM   (current month, e.g. "2026-06")
    //   → Record<string, number>
    //   Map: entries → CategoryPoint[], compute pct = (value / totalSpent) * 100

    // API CALL: GET /api/analytics/anomalies
    //   → AnomalyDTO[] { transactionId, description, counterpart, amount, date, categoryName, reason }

    // API CALL: GET /api/transactions
    //   → TransactionResponse[] { id, amount, transactionDate, categoryName, isAnomaly, geminiUsed, ... }
    //   Compute income     = sum of positive amounts for current month
    //   Compute txCount    = array length
    //   Compute aiAccuracy = transactions with geminiUsed=true / total * 100  (or categorized/total)
    //   Compute currentMonth from most recent transactionDate
  }, [])

  if (!data) {
    return (
      <div className="grid place-items-center h-screen">
        <span className="text-gray-600 font-mono text-sm">loading...</span>
      </div>
    )
  }

  return (
    <div className="grid gap-5 p-4 md:gap-6 md:p-6 lg:p-8">

      {/* Header */}
      <div className="grid gap-1">
        <h1 className="text-4xl font-black tracking-tight text-white md:text-4xl lg:text-4xl">Dashboard</h1>
        <p className="text-gray-500 font-mono text-sm">
          // {data.currentMonth} · {data.txCount} transactions
        </p>
      </div>

      {/* Stats — 2 cols on mobile/tablet, 4 on desktop */}
      <div className="grid grid-cols-2 gap-3 lg:grid-cols-4 lg:gap-4">
        <StatCard label="Total Spent"  value={`€${data.totalSpent.toLocaleString('de-DE')}`} sub="this month"          color="text-red-400"   />
        <StatCard label="Income"       value={`€${data.income.toLocaleString('de-DE')}`}     sub="this month"          color="text-green-400" />
        <StatCard label="Anomalies"    value={String(data.anomalyCount)}                     sub="flagged transactions" color="text-green-400" />
        <StatCard label="AI Accuracy"  value={`${data.aiAccuracy}%`}                         sub="categorized"         color="text-green-400" />
      </div>

      {/* Charts — stacked on mobile/tablet, side by side on desktop */}
      <div className="grid grid-cols-1 gap-4 lg:grid-cols-[3fr_2fr]">

        {/* Monthly spending bar chart */}
        <div className="grid gap-5 bg-[#111] rounded-2xl border border-[#2a2a2a] p-4 lg:p-6">
          <div className="flex items-center justify-between">
            <h2 className="text-white font-semibold">Monthly Spending</h2>
            <span className="text-gray-500 font-mono text-xs">last 6 months</span>
          </div>
          <ResponsiveContainer width="100%" height={190}>
            <BarChart data={data.monthly} margin={{ top: 24, right: 8, left: 8, bottom: 0 }}>
              <XAxis
                dataKey="month"
                axisLine={false}
                tickLine={false}
                tick={{ fill: '#6b7280', fontSize: 11, fontFamily: 'monospace' }}
              />
              <Tooltip
                cursor={{ fill: 'rgba(255,255,255,0.04)' }}
                contentStyle={{ background: '#1a1a1a', border: '1px solid #2a2a2a', borderRadius: 10, fontFamily: 'monospace', fontSize: 12 }}
                labelStyle={{ color: '#9ca3af' }}
                formatter={(value: unknown) => [fmtEuro(value as number), 'Spent']}
              />
              <Bar dataKey="amount" fill="#22c55e" radius={[5, 5, 2, 2]}>
                <LabelList
                  dataKey="amount"
                  position="top"
                  formatter={fmtK}
                  style={{ fill: '#9ca3af', fontSize: 10, fontFamily: 'monospace' }}
                />
              </Bar>
            </BarChart>
          </ResponsiveContainer>
        </div>

        {/* Category donut + legend */}
        <div className="grid gap-5 bg-[#111] rounded-2xl border border-[#2a2a2a] p-4 lg:p-6">
          <div className="flex items-center justify-between">
            <h2 className="text-white font-semibold">By Category</h2>
            <span className="text-gray-500 font-mono text-xs">{data.currentMonth}</span>
          </div>

          <div className="flex items-center gap-2">
            {/* Donut */}
            <div className="shrink-0">
              <PieChart width={150} height={150}>
                <Pie
                  data={data.categories}
                  cx="50%"
                  cy="50%"
                  innerRadius={46}
                  outerRadius={70}
                  dataKey="value"
                  strokeWidth={2}
                  stroke="#111"
                >
                  {data.categories.map((_, i) => (
                    <Cell key={i} fill={CAT_COLORS[i % CAT_COLORS.length]} />
                  ))}
                </Pie>
              </PieChart>
            </div>

            {/* Legend */}
            <div className="flex-1 grid gap-2.5">
              {data.categories.map((cat, i) => (
                <div key={cat.name} className="grid grid-cols-[auto_1fr_auto] items-center gap-2">
                  <div className="w-2.5 h-2.5 rounded-sm shrink-0" style={{ background: CAT_COLORS[i % CAT_COLORS.length] }} />
                  <span className="text-white text-sm truncate">{cat.name}</span>
                  <span className="text-gray-400 text-sm font-mono">{cat.pct}%</span>
                </div>
              ))}
            </div>
          </div>
        </div>

      </div>

      {/* Anomaly Alerts */}
      <div className="grid gap-4 bg-[#111] rounded-2xl border border-[#2a2a2a] p-4 lg:p-6">
        <div className="flex items-center justify-between">
          <h2 className="text-white font-semibold">Anomaly Alerts</h2>
          <span className="text-red-400 font-mono text-xs">{data.anomalyCount} flagged</span>
        </div>

        <div className="grid gap-2">
          {data.anomalies.map((a) => (
            <div
              key={a.transactionId}
              className="grid grid-cols-[auto_1fr_auto] items-center gap-4 px-4 py-3.5 rounded-xl bg-[#0e0e0e] border border-[#1e1e1e]"
            >
              <div className="grid place-items-center w-8 h-8 rounded-lg bg-amber-500/10 shrink-0">
                <WarnIcon />
              </div>
              <div className="grid gap-0.5 min-w-0">
                <span className="text-white text-sm font-medium truncate">{a.description}</span>
                <span className="text-gray-500 font-mono text-xs">{a.reason}</span>
              </div>
              <span className="text-red-400 font-mono text-sm font-medium shrink-0 tabular-nums">
                -{fmtEuro(a.amount)}
              </span>
            </div>
          ))}
        </div>
      </div>

    </div>
  )
}

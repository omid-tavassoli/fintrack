'use client'

import api from '@/lib/api'
import { useEffect, useMemo, useState } from 'react'
import {
  BarChart, Bar, XAxis, YAxis, Tooltip, ResponsiveContainer, LabelList,
  LineChart, Line,
  PieChart, Pie, Cell, ReferenceLine,
} from 'recharts'

// ── Types ──────────────────────────────────────────────────────────────────────
interface MonthlyPoint   { month: string; amount: number }
interface CategoryPoint  { name: string; value: number; pct: number }
interface AnomalyItem    { transactionId: number; description: string; amount: number; reason: string }
interface DailyPoint     { day: string; income: number; spend: number; net: number; netPos: number | null; netNeg: number | null }
interface RawTx          { amount: number; transactionDate: string }
interface DashboardData  {
  totalSpent: number
  income: number
  anomalyCount: number
  aiAccuracy: number
  txCount: number
  currentMonth: string
  latestMonth: string
  monthly: MonthlyPoint[]
  categories: CategoryPoint[]
  anomalies: AnomalyItem[]
  availableMonths: string[]
  allTx: RawTx[]
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

interface TooltipProps { active?: boolean; payload?: { payload: DailyPoint }[]; label?: string }
function CashFlowTooltip({ active, payload, label }: TooltipProps) {
  if (!active || !payload?.length) return null
  const d = payload[0].payload
  return (
    <div className="bg-[#1a1a1a] border border-[#2a2a2a] rounded-xl px-4 py-3 font-mono text-xs grid gap-1.5 shadow-xl">
      <p className="text-gray-500 mb-0.5">Day {label}</p>
      <p className="text-green-400">Income  <span className="ml-2 text-white">{fmtEuro(d.income)}</span></p>
      <p className="text-red-400">Spend   <span className="ml-2 text-white">{fmtEuro(d.spend)}</span></p>
      <p className={`border-t border-[#2a2a2a] pt-1.5 mt-0.5 font-semibold ${d.net >= 0 ? 'text-green-400' : 'text-red-400'}`}>
        Net     <span className="ml-2 text-white">{d.net >= 0 ? '+' : ''}{fmtEuro(d.net)}</span>
      </p>
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
    async function fetchDashboard() {
  const [monthlyRes, anomaliesRes, txRes] = await Promise.all([
    api.get('/api/analytics/monthly'),
    api.get('/api/analytics/anomalies'),
    api.get('/api/transactions'),
  ])

  const monthlyData = monthlyRes.data as { month: string; total: number }[]

  // use the most recent month with actual data, not today's date
  const latestMonth = monthlyData.length > 0 ? monthlyData[0].month : new Date().toISOString().slice(0, 7)

  const categoriesRes = await api.get(`/api/analytics/categories?month=${latestMonth}`)

  const monthly: MonthlyPoint[] = monthlyData
    .slice(0, 6)
    .reverse()
    .map((m) => ({
      month: new Date(m.month + '-01').toLocaleDateString('en-GB', { month: 'short' }),
      amount: Math.abs(m.total),
    }))

  const catData = categoriesRes.data as Record<string, number>
  const totalSpent = Object.values(catData).reduce((s, v) => s + Math.abs(v), 0)
  const categories: CategoryPoint[] = Object.entries(catData)
    .sort((a, b) => Math.abs(b[1]) - Math.abs(a[1]))
    .slice(0, 5)
    .map(([name, value]) => ({
      name,
      value: Math.abs(value),
      pct: totalSpent > 0 ? Math.round((Math.abs(value) / totalSpent) * 100) : 0,
    }))

  const txList = txRes.data
  const income = txList
    .filter((t: { amount: number; transactionDate: string }) =>
      t.amount > 0 && t.transactionDate.startsWith(latestMonth))
    .reduce((s: number, t: { amount: number }) => s + t.amount, 0)

  const categorized = txList.filter((t: { categoryName: string }) => t.categoryName).length
  const aiAccuracy = txList.length > 0
    ? Math.round((categorized / txList.length) * 100 * 10) / 10
    : 0

  setData({
    totalSpent: Math.round(totalSpent),
    income: Math.round(income),
    anomalyCount: anomaliesRes.data.length,
    aiAccuracy,
    txCount: txList.length,
    latestMonth,
    currentMonth: new Date(latestMonth + '-01').toLocaleDateString('en-GB', { month: 'long', year: 'numeric' }),
    monthly,
    categories,
    anomalies: anomaliesRes.data,
    availableMonths: monthlyData.map((m: { month: string }) => m.month).sort(),
    allTx: txList.map((t: { amount: number; transactionDate: string }) => ({
      amount: t.amount,
      transactionDate: t.transactionDate,
    })),
  })
}

    fetchDashboard().catch(console.error)
  }, [])

  // ── Cash flow month navigation ───────────────────────────────────────────────
  const [cashFlowMonth, setCashFlowMonth] = useState('')

  useEffect(() => {
    if (data?.latestMonth && !cashFlowMonth) setCashFlowMonth(data.latestMonth)
  }, [data, cashFlowMonth])

  const daily = useMemo((): DailyPoint[] => {
    if (!data || !cashFlowMonth) return []
    const dayMap: Record<string, { income: number; expenses: number }> = {}
    data.allTx.forEach(t => {
      if (!t.transactionDate.startsWith(cashFlowMonth)) return
      const day = t.transactionDate.slice(8, 10)
      if (!dayMap[day]) dayMap[day] = { income: 0, expenses: 0 }
      if (t.amount > 0) dayMap[day].income += t.amount
      else              dayMap[day].expenses += t.amount
    })
    let cumulative = 0
    return Object.entries(dayMap)
      .sort(([a], [b]) => a.localeCompare(b))
      .map(([day, v]) => {
        const dailyNet = Math.round(v.income + v.expenses)
        cumulative += dailyNet
        return {
          day,
          income:  Math.round(v.income),
          spend:   Math.round(Math.abs(v.expenses)),
          net:     cumulative,
          netPos: dailyNet >= 0 ? dailyNet : null,
          netNeg: dailyNet <  0 ? dailyNet : null,
        }
      })
  }, [data, cashFlowMonth])

  const monthIdx        = data?.availableMonths.indexOf(cashFlowMonth) ?? -1
  const canGoBack       = monthIdx > 0
  const canGoForward    = data ? monthIdx < data.availableMonths.length - 1 : false
  const cashFlowLabel   = cashFlowMonth
    ? new Date(cashFlowMonth + '-01').toLocaleDateString('en-GB', { month: 'long', year: 'numeric' })
    : ''

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
        <StatCard label="Total Spent"  value={`€${data.totalSpent.toLocaleString('de-DE')}`} sub={data.currentMonth} color="text-red-400"   />
        <StatCard label="Income"       value={`€${data.income.toLocaleString('de-DE')}`}     sub={data.currentMonth} color="text-green-400" />
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

      {/* Cash Flow */}
      <div className="grid gap-5 bg-[#111] rounded-2xl border border-[#2a2a2a] p-4 lg:p-6">
        {/* Header with month navigation */}
        <div className="flex items-center justify-between">
          <div className="flex items-center gap-4">
              <h2 className="text-white font-semibold">Cash Flow</h2>
              <div className="flex items-center gap-3">
                <span className="flex items-center gap-1.5 text-gray-500 font-mono text-xs">
                  <span className="w-2.5 h-2.5 rounded-sm bg-green-400 inline-block" /> income
                </span>
                <span className="flex items-center gap-1.5 text-gray-500 font-mono text-xs">
                  <span className="w-2.5 h-2.5 rounded-sm bg-red-400 inline-block" /> spend
                </span>
              </div>
            </div>
          <div className="flex items-center gap-2">
            <button
              onClick={() => data && canGoBack && setCashFlowMonth(data.availableMonths[monthIdx - 1])}
              disabled={!canGoBack}
              className="w-7 h-7 grid place-items-center rounded-lg border border-[#2a2a2a] text-gray-400 hover:text-white hover:border-[#444] disabled:opacity-30 disabled:cursor-not-allowed transition-colors text-sm"
            >
              ←
            </button>
            <span className="text-gray-400 font-mono text-xs w-28 text-center">{cashFlowLabel}</span>
            <button
              onClick={() => data && canGoForward && setCashFlowMonth(data.availableMonths[monthIdx + 1])}
              disabled={!canGoForward}
              className="w-7 h-7 grid place-items-center rounded-lg border border-[#2a2a2a] text-gray-400 hover:text-white hover:border-[#444] disabled:opacity-30 disabled:cursor-not-allowed transition-colors text-sm"
            >
              →
            </button>
          </div>
        </div>

        {/* Chart with blur overlay when no data */}
        <div className="relative">
          <div className={daily.length === 0 ? 'blur-sm pointer-events-none' : ''}>
            <ResponsiveContainer width="100%" height={260}>
              <LineChart data={daily} margin={{ top: 8, right: 8, left: 8, bottom: 0 }}>
                <XAxis
                  dataKey="day"
                  axisLine={false}
                  tickLine={false}
                  tick={{ fill: '#6b7280', fontSize: 10, fontFamily: 'monospace' }}
                />
                <YAxis hide />
                <ReferenceLine y={0} stroke="#2a2a2a" strokeWidth={1} />
                <Tooltip content={<CashFlowTooltip />} cursor={{ stroke: 'rgba(255,255,255,0.1)' }} />
                <Line
                  dataKey="net"
                  type="monotone"
                  stroke="#4ade80"
                  strokeWidth={2}
                  dot={{ r: 3, fill: '#4ade80', strokeWidth: 0 }}
                  activeDot={{ r: 5, fill: '#4ade80', strokeWidth: 0 }}
                />
              </LineChart>
            </ResponsiveContainer>
          </div>

          {daily.length === 0 && (
            <div className="absolute inset-0 grid place-items-center">
              <div className="grid gap-2 text-center">
                <p className="text-white text-xl font-semibold">No data available</p>
                <p className="text-gray-500 font-mono text-sm">No transactions found for {cashFlowLabel}</p>
              </div>
            </div>
          )}
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

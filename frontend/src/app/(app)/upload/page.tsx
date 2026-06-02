'use client'

import { useEffect, useRef, useState } from 'react'
import api from '@/lib/api'

interface ImportResult {
  imported: number
  skipped: number
  categorized: number
  geminiCalls: number
  bank?: string
  period?: string
}

const BANKS = ['Postbank', 'Sparkasse', 'Commerzbank', 'Deutsche Bank', 'ING', 'Revolut', 'N26']

const DEMO_RESULT: ImportResult = {
  imported: 127, skipped: 0, categorized: 125, geminiCalls: 76,
  bank: 'Postbank', period: 'Oct 2025',
}

function DocIcon() {
  return (
    <svg width="48" height="56" viewBox="0 0 48 56" fill="none">
      <rect x="4" y="2" width="32" height="42" rx="3" fill="#2a2a2a" stroke="#3a3a3a" strokeWidth="1.5" />
      <path d="M36 2l8 8h-8V2z" fill="#3a3a3a" />
      <rect x="10" y="16" width="20" height="2" rx="1" fill="#4a4a4a" />
      <rect x="10" y="22" width="16" height="2" rx="1" fill="#4a4a4a" />
      <rect x="10" y="28" width="18" height="2" rx="1" fill="#4a4a4a" />
    </svg>
  )
}

type State = 'idle' | 'dragging' | 'uploading' | 'done' | 'error'

export default function UploadPage() {
  const [state, setState] = useState<State>('idle')
  const [result, setResult] = useState<ImportResult | null>(null)
  const [error, setError] = useState('')
  const [fileName, setFileName] = useState('')
  const inputRef = useRef<HTMLInputElement>(null)

  useEffect(() => {
    if (localStorage.getItem('isDemo') === 'true') {
      setResult(DEMO_RESULT)
    }
  }, [])

  async function handleFile(file: File | undefined) {
    if (!file) return
    if (!file.name.endsWith('.pdf')) {
      setError('Only PDF files are supported.')
      return
    }
    setFileName(file.name)
    setError('')
    setState('uploading')

    const isDemo = localStorage.getItem('isDemo') === 'true'
    if (isDemo) {
      // Fake upload delay in demo mode
      await new Promise(r => setTimeout(r, 1800))
      setResult({ ...DEMO_RESULT, period: 'Demo' })
      setState('done')
      return
    }

    try {
      // API CALL: POST /api/transactions/upload
      //   multipart form-data, field name: "file"
      //   → IngestionSummary { imported, skipped, categorized, uncategorized, geminiCalls }
      const form = new FormData()
      form.append('file', file)
      const { data } = await api.post('/api/transactions/upload', form, {
        headers: { 'Content-Type': 'multipart/form-data' },
      })
      setResult({
        imported:     data.imported,
        skipped:      data.skipped,
        categorized:  data.categorized,
        geminiCalls:  data.geminiCalls,
        period:       new Date().toLocaleDateString('en-GB', { month: 'short', year: 'numeric' }),
      })
      setState('done')
    } catch {
      setError('Upload failed. Make sure the backend is running.')
      setState('error')
    }
  }

  return (
    <div className="grid gap-5 p-4 md:gap-6 md:p-6 lg:p-8">

      {/* Header */}
      <div className="grid gap-1">
        <h1 className="text-4xl font-black tracking-tight text-white md:text-4xl lg:text-4xl">Upload Statement</h1>
        <p className="text-gray-500 font-mono text-sm">// supports all German banks via PDF</p>
      </div>

      {/* Drop zone */}
      <div className="bg-[#111] rounded-2xl border border-[#2a2a2a] p-4">
        <input
          ref={inputRef}
          type="file"
          accept=".pdf"
          className="hidden"
          onChange={e => handleFile(e.target.files?.[0])}
        />

        <div
          onClick={() => state !== 'uploading' && inputRef.current?.click()}
          onDragOver={e => { e.preventDefault(); setState('dragging') }}
          onDragLeave={() => setState(s => s === 'dragging' ? 'idle' : s)}
          onDrop={e => { e.preventDefault(); handleFile(e.dataTransfer.files[0]) }}
          className={`grid place-items-center gap-4 border-2 border-dashed rounded-xl py-16 px-6 cursor-pointer transition-colors select-none ${
            state === 'dragging'
              ? 'border-green-500/60 bg-green-500/5'
              : 'border-[#2a2a2a] hover:border-[#444] hover:bg-[#131313]'
          }`}
        >
          {state === 'uploading' ? (
            <div className="grid place-items-center gap-3">
              <div className="w-10 h-10 rounded-full border-2 border-green-500 border-t-transparent animate-spin" />
              <p className="text-gray-400 font-mono text-sm">Uploading {fileName}...</p>
            </div>
          ) : (
            <div className="grid place-items-center gap-3 text-center">
              <DocIcon />
              <div className="grid gap-1">
                <p className="text-white font-semibold text-lg">Drop your bank statement here</p>
                <p className="text-gray-500 text-sm">PDF format · all German banks supported</p>
              </div>
              {/* Bank pills */}
              <div className="flex flex-wrap justify-center gap-2 mt-2">
                {BANKS.map(b => (
                  <span key={b} className="px-3 py-1 rounded-full border border-[#2a2a2a] text-gray-500 text-xs">
                    {b}
                  </span>
                ))}
              </div>
              {error && <p className="text-red-400 font-mono text-sm">{error}</p>}
            </div>
          )}
        </div>
      </div>

      {/* Last import result */}
      {result && (
        <div className="grid gap-5 bg-[#111] rounded-2xl border border-[#2a2a2a] p-5 lg:p-6">
          <div className="flex items-center justify-between">
            <h2 className="text-white font-semibold">Last Import Result</h2>
            {(result.period || result.bank) && (
              <span className="text-gray-500 font-mono text-xs">
                {[result.period, result.bank].filter(Boolean).join(' · ')}
              </span>
            )}
          </div>

          {/* Stats — 2 cols on mobile, 4 on desktop */}
          <div className="grid grid-cols-2 gap-4 lg:grid-cols-4">
            <ResultStat label="Imported"     value={result.imported}    color="text-green-400" />
            <ResultStat label="Skipped"      value={result.skipped}     color="text-gray-500"  />
            <ResultStat label="Categorized"  value={result.categorized} color="text-green-400" />
            <ResultStat label="Gemini Calls" value={result.geminiCalls} color="text-amber-400" />
          </div>
        </div>
      )}

    </div>
  )
}

function ResultStat({ label, value, color }: { label: string; value: number; color: string }) {
  return (
    <div className="grid gap-2">
      <span className="text-gray-600 font-mono text-xs uppercase tracking-widest">{label}</span>
      <span className={`font-mono text-4xl font-bold leading-none ${color}`}>{value}</span>
    </div>
  )
}

'use client'

import { useCallback, useEffect, useRef, useState } from 'react'
import { useRouter } from 'next/navigation'
import api from '@/lib/api'

interface IngestionSummary {
  imported: number
  skipped: number
  categorized: number
  uncategorized: number
  geminiCalls: number
}

export default function UploadPage() {
  const router = useRouter()
  const [state, setState] = useState<'idle' | 'uploading' | 'done'>('idle')
  const [fileName, setFileName] = useState('')
  const [result, setResult] = useState<IngestionSummary | null>(null)
  const [error, setError] = useState('')
  const [isDragging, setIsDragging] = useState(false)
  const [isDemo, setIsDemo] = useState(false)
  const inputRef = useRef<HTMLInputElement>(null)

  useEffect(() => {
    const email = localStorage.getItem('userEmail')
    setIsDemo(email === 'demo@fintrack.com')
  }, [])

  async function handleUpload(file: File) {
    if (isDemo) {
      setError('Upload is not available in demo mode. Create an account to upload your own bank statements.')
      return
    }

    if (!file || file.type !== 'application/pdf') {
      setError('Please upload a PDF file.')
      return
    }

    setError('')
    setFileName(file.name)
    setState('uploading')

    const form = new FormData()
    form.append('file', file)

    try {
      const { data } = await api.post<IngestionSummary>(
        '/api/transactions/upload', form
      )
      setResult(data)
      setState('done')
    } catch (err: unknown) {
      setState('idle')
      const msg =
        err && typeof err === 'object' && 'response' in err
          ? (err as { response?: { data?: { message?: string } } })
              .response?.data?.message
          : undefined
      setError(msg || 'Upload failed. Please try again.')
    }
  }

  function handleFileInput(e: React.ChangeEvent<HTMLInputElement>) {
    const file = e.target.files?.[0]
    if (file) handleUpload(file)
    e.target.value = ''
  }

  const handleDrop = useCallback((e: React.DragEvent) => {
    e.preventDefault()
    setIsDragging(false)
    if (isDemo) {
      setError('Upload is not available in demo mode. Create an account to upload your own bank statements.')
      return
    }
    const file = e.dataTransfer.files[0]
    if (file) handleUpload(file)
  }, [isDemo])

  function handleDragOver(e: React.DragEvent) {
    e.preventDefault()
    setIsDragging(true)
  }

  function handleDragLeave() {
    setIsDragging(false)
  }

  function reset() {
    setState('idle')
    setFileName('')
    setResult(null)
    setError('')
  }

  return (
    <div className="grid gap-5 p-4 md:gap-6 md:p-6 lg:p-8">

      {/* Header */}
      <div className="grid gap-1">
        <h1 className="text-4xl font-black tracking-tight text-white">Upload Statement</h1>
        <p className="text-gray-500 font-mono text-sm">// supports all German banks via PDF</p>
      </div>

      {/* Demo banner */}
      {isDemo && (
        <div className="bg-[#1a1a1a] border border-amber-900/40 rounded-xl px-5 py-4 flex items-start gap-3">
          <span className="text-amber-400 text-lg shrink-0">⚠</span>
          <div className="grid gap-1">
            <p className="text-amber-400 font-mono text-sm font-medium">
              Demo mode — uploads disabled
            </p>
            <p className="text-gray-500 font-mono text-xs">
              You are viewing a demo account with preloaded data.{' '}
              <button
                onClick={() => router.push('/login')}
                className="text-green-400 underline hover:text-green-300 transition-colors"
              >
                Create an account
              </button>
              {' '}to upload your own bank statements.
            </p>
          </div>
        </div>
      )}

      {/* Upload zone */}
      <div
        onDrop={handleDrop}
        onDragOver={handleDragOver}
        onDragLeave={handleDragLeave}
        onClick={() => state === 'idle' && inputRef.current?.click()}
        className={`
          border-2 border-dashed rounded-2xl p-12 text-center transition-all
          ${state === 'idle' && !isDemo ? 'cursor-pointer' : 'cursor-default'}
          ${isDragging && !isDemo
            ? 'border-green-500 bg-green-500/5'
            : 'border-[#2a2a2a] hover:border-[#3a3a3a]'
          }
        `}
      >
        <input
          ref={inputRef}
          type="file"
          accept=".pdf"
          onChange={handleFileInput}
          className="hidden"
        />

        {/* Idle state */}
        {state === 'idle' && (
          <div className="grid place-items-center gap-4">
            <div className="text-5xl">📄</div>
            <div className="grid gap-1">
              <p className="text-white font-semibold text-lg">
                {isDemo ? 'Upload not available in demo mode' : 'Drop your bank statement here'}
              </p>
              <p className="text-gray-500 font-mono text-sm">
                {isDemo
                  ? 'Create an account to upload your own statements'
                  : 'PDF format · all German banks supported'
                }
              </p>
            </div>
            {!isDemo && (
              <div className="flex flex-wrap gap-2 justify-center mt-2">
                {['Postbank', 'Sparkasse', 'Commerzbank', 'Deutsche Bank', 'ING', 'Revolut', 'N26'].map(bank => (
                  <span
                    key={bank}
                    className="px-3 py-1 bg-[#1a1a1a] border border-[#2a2a2a] rounded-full text-gray-500 font-mono text-xs"
                  >
                    {bank}
                  </span>
                ))}
              </div>
            )}
          </div>
        )}

        {/* Uploading state */}
        {state === 'uploading' && (
          <div className="grid place-items-center gap-4">
            <div className="w-10 h-10 border-2 border-green-500 border-t-transparent rounded-full animate-spin" />
            <div className="grid gap-1">
              <p className="text-white font-mono text-sm">Uploading {fileName}</p>
              <p className="text-gray-600 font-mono text-xs">
                Processing transactions — this may take a few minutes
              </p>
            </div>
          </div>
        )}

        {/* Done state */}
        {state === 'done' && result && (
          <div className="grid place-items-center gap-4">
            <div className="text-4xl">✓</div>
            <p className="text-green-400 font-mono text-sm font-medium">Upload complete</p>
            <button
              onClick={e => { e.stopPropagation(); reset() }}
              className="text-gray-500 text-xs font-mono underline hover:text-gray-400 transition-colors"
            >
              Upload another
            </button>
          </div>
        )}
      </div>

      {/* Error message */}
      {error && (
        <div className="bg-[#1a1a1a] border border-red-900/40 rounded-xl px-5 py-4">
          <p className="text-red-400 font-mono text-sm">{error}</p>
          {isDemo && (
            <button
              onClick={() => router.push('/login')}
              className="text-green-400 text-xs font-mono underline mt-2 block hover:text-green-300 transition-colors"
            >
              Create an account →
            </button>
          )}
        </div>
      )}

      {/* Result summary */}
      {result && (
        <div className="bg-[#111] rounded-2xl border border-[#2a2a2a] p-5 lg:p-6">
          <span className="text-gray-600 font-mono text-xs uppercase tracking-widest">
            Import Result — {fileName}
          </span>
          <div className="grid grid-cols-2 gap-4 mt-4 lg:grid-cols-5">
            {[
              { label: 'Imported',      value: result.imported,      color: 'text-green-400'  },
              { label: 'Skipped',       value: result.skipped,       color: 'text-gray-500'   },
              { label: 'Categorized',   value: result.categorized,   color: 'text-green-400'  },
              { label: 'Uncategorized', value: result.uncategorized, color: 'text-amber-400'  },
              { label: 'Gemini Calls',  value: result.geminiCalls,   color: 'text-teal-400'   },
            ].map(s => (
              <div key={s.label} className="grid gap-1">
                <span className="text-gray-600 font-mono text-xs uppercase tracking-widest">{s.label}</span>
                <span className={`font-mono text-2xl font-bold ${s.color}`}>{s.value}</span>
              </div>
            ))}
          </div>
        </div>
      )}

    </div>
  )
}
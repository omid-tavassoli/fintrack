'use client'

import { useEffect, useRef, useState } from 'react'
import api from '@/lib/api'

// ── Demo conversation ─────────────────────────────────────────────────────────
const DEMO_MESSAGES = [
  { role: 'user',      content: 'How much did I spend on restaurants in October?' },
  { role: 'assistant', content: 'You spent €73.20 on restaurants in October 2025 across 6 transactions. That\'s slightly above your monthly average of €58.40.' },
  { role: 'user',      content: 'Which restaurant was the most expensive?' },
  { role: 'assistant', content: 'Your most expensive restaurant visit was **Restaurant Hani** in Frankfurt on October 13th at €41.00 — this was also flagged as an anomaly since it\'s 4.2× your average restaurant spend.' },
]

const SUGGESTIONS = [
  'How much did I spend last month?',
  'What is my biggest expense?',
  'Was habe ich für Lebensmittel ausgegeben?',
  'Show me my subscription costs',
  'Am I over budget this month?',
]

// ── Types ──────────────────────────────────────────────────────────────────────
interface Message { role: 'user' | 'assistant'; content: string }

// ── Helpers ────────────────────────────────────────────────────────────────────
// Highlight €amounts and **bold** in AI messages
function renderContent(text: string) {
  // Split on €number or **word**
  const parts = text.split(/(\*\*[^*]+\*\*|€[\d.,]+)/g)
  return parts.map((p, i) => {
    if (/^\*\*[^*]+\*\*$/.test(p)) return <strong key={i} className="font-semibold text-white">{p.slice(2, -2)}</strong>
    if (/^€[\d.,]+$/.test(p))       return <span key={i} className="text-green-400 font-semibold">{p}</span>
    return p
  })
}

// ── Page ───────────────────────────────────────────────────────────────────────
export default function ChatPage() {
  const [messages, setMessages] = useState<Message[]>([])
  const [input, setInput] = useState('')
  const [loading, setLoading] = useState(false)
  const [userInitials, setUserInitials] = useState('OT')
  const bottomRef = useRef<HTMLDivElement>(null)
  const inputRef = useRef<HTMLInputElement>(null)

  useEffect(() => {
    const email = localStorage.getItem('userEmail') || ''
    if (email) setUserInitials(email.split('@')[0].slice(0, 2).toUpperCase())
    // Pre-load demo conversation
    setMessages(DEMO_MESSAGES as Message[])
  }, [])

  // Auto-scroll to latest message
  useEffect(() => {
    bottomRef.current?.scrollIntoView({ behavior: 'smooth' })
  }, [messages, loading])

  async function sendMessage(text: string) {
    const trimmed = text.trim()
    if (!trimmed || loading) return

    const userMsg: Message = { role: 'user', content: trimmed }
    const history = messages // everything so far becomes history
    setMessages(prev => [...prev, userMsg])
    setInput('')
    setLoading(true)

    try {
      // API CALL: POST /api/chat
      //   → body: { message: trimmed, history: [{role, content}, ...] }
      //   → ChatResponse { message: string, data: object[] }
      const { data } = await api.post('/api/chat', { message: trimmed, history })
      setMessages(prev => [...prev, { role: 'assistant', content: data.message }])
    } catch {
      setMessages(prev => [...prev, {
        role: 'assistant',
        content: 'Could not reach the backend. Make sure the Spring Boot server is running.',
      }])
    } finally {
      setLoading(false)
      inputRef.current?.focus()
    }
  }

  function handleKeyDown(e: React.KeyboardEvent<HTMLInputElement>) {
    if (e.key === 'Enter' && !e.shiftKey) { e.preventDefault(); sendMessage(input) }
  }

  return (
    <div className="grid gap-5 p-4 md:gap-6 md:p-6 lg:p-8" style={{ height: '100%' }}>

      {/* Header */}
      <div className="grid gap-1">
        <h1 className="text-4xl font-black tracking-tight text-white md:text-4xl lg:text-4xl">AI Chat</h1>
        <p className="text-gray-500 font-mono text-sm">// ask anything about your finances</p>
      </div>

      {/* Suggested questions */}
      <div className="grid gap-3">
        <span className="text-gray-600 font-mono text-xs uppercase tracking-widest">Suggested Questions</span>
        <div className="flex flex-wrap gap-2">
          {SUGGESTIONS.map(s => (
            <button
              key={s}
              onClick={() => { setInput(s); inputRef.current?.focus() }}
              className="px-4 py-2 rounded-full border border-[#2a2a2a] text-gray-400 text-sm hover:border-[#444] hover:text-white transition-colors"
            >
              {s}
            </button>
          ))}
        </div>
      </div>

      {/* Chat card */}
      <div className="flex flex-col bg-[#111] rounded-2xl border border-[#2a2a2a] overflow-hidden" style={{ minHeight: '400px', height: 'calc(100vh - 380px)' }}>

        {/* Messages */}
        <div className="flex-1 overflow-y-auto p-5 grid gap-4 content-start">
          {messages.map((m, i) => (
            <div key={i} className={`flex items-start gap-3 ${m.role === 'assistant' ? 'justify-end' : ''}`}>

              {m.role === 'user' && (
                <>
                  <div className="grid place-items-center w-8 h-8 rounded-full bg-[#2a2a2a] text-white text-xs font-bold shrink-0 mt-0.5">
                    {userInitials}
                  </div>
                  <div className="bg-[#1a1a1a] border border-[#2a2a2a] rounded-2xl rounded-tl-sm px-4 py-3 max-w-[75%]">
                    <p className="text-white text-sm leading-relaxed">{m.content}</p>
                  </div>
                </>
              )}

              {m.role === 'assistant' && (
                <>
                  <div className="bg-[#1a3320] border border-green-900/40 rounded-2xl rounded-tr-sm px-4 py-3 max-w-[75%]">
                    <p className="text-gray-100 text-sm leading-relaxed">{renderContent(m.content)}</p>
                  </div>
                  <div className="grid place-items-center w-8 h-8 rounded-full bg-green-600 text-black text-xs font-bold shrink-0 mt-0.5">
                    AI
                  </div>
                </>
              )}

            </div>
          ))}

          {/* Typing indicator */}
          {loading && (
            <div className="flex items-start gap-3 justify-end">
              <div className="bg-[#1a3320] border border-green-900/40 rounded-2xl rounded-tr-sm px-5 py-4">
                <div className="flex gap-1.5 items-center">
                  <div className="w-1.5 h-1.5 rounded-full bg-green-400 animate-bounce [animation-delay:0ms]" />
                  <div className="w-1.5 h-1.5 rounded-full bg-green-400 animate-bounce [animation-delay:150ms]" />
                  <div className="w-1.5 h-1.5 rounded-full bg-green-400 animate-bounce [animation-delay:300ms]" />
                </div>
              </div>
              <div className="grid place-items-center w-8 h-8 rounded-full bg-green-600 text-black text-xs font-bold shrink-0">
                AI
              </div>
            </div>
          )}

          <div ref={bottomRef} />
        </div>

        {/* Input row */}
        <div className="flex items-center gap-3 p-4 border-t border-[#1e1e1e]">
          <input
            ref={inputRef}
            type="text"
            value={input}
            onChange={e => setInput(e.target.value)}
            onKeyDown={handleKeyDown}
            placeholder="Ask about your finances..."
            disabled={loading}
            className="flex-1 bg-transparent text-white text-sm placeholder-gray-600 outline-none disabled:opacity-50"
          />
          <button
            onClick={() => sendMessage(input)}
            disabled={loading || !input.trim()}
            className="px-5 py-2.5 rounded-xl bg-green-500 text-black font-semibold text-sm hover:bg-green-400 transition-colors disabled:opacity-40 shrink-0"
          >
            Send
          </button>
        </div>

      </div>
    </div>
  )
}

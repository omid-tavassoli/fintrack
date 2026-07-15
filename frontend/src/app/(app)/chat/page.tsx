'use client'

import { useEffect, useRef, useState } from 'react'
import api from '@/lib/api'

const WELCOME_MESSAGE = [
  {
    role: 'assistant' as const,
    content: 'Hi! I\'m your AI finance assistant.\nI can access your transaction history and help you manage your money.\nAsk me anything — in English or German.',
  },
]

const SUGGESTIONS = [
  'What is my biggest expense?',
  'Show me my subscription costs',
  'Am I over budget this month?',
  'How much did I spend on food last month?',
]

interface Message { role: 'user' | 'assistant'; content: string }

function renderContent(text: string) {
  const parts = text.split(/(\*\*[^*]+\*\*|€[\d.,]+)/g)
  return parts.map((p, i) => {
    if (/^\*\*[^*]+\*\*$/.test(p)) return <strong key={i} className="font-semibold text-white">{p.slice(2, -2)}</strong>
    if (/^€[\d.,]+$/.test(p)) return <span key={i} className="text-green-400 font-semibold">{p}</span>
    return p
  })
}

function AIIcon() {
  return (
    <svg width="14" height="14" viewBox="0 0 16 16" fill="none">
      <path d="M8 2C8 4.5 5.5 7 3 7C5.5 7 8 9.5 8 12C8 9.5 10.5 7 13 7C10.5 7 8 4.5 8 2Z" fill="#000" />
    </svg>
  )
}

export default function ChatPage() {
  const [messages, setMessages] = useState<Message[]>([])
  const [apiHistory, setApiHistory] = useState<Message[]>([])
  const [input, setInput] = useState('')
  const [loading, setLoading] = useState(false)
  const [userInitials, setUserInitials] = useState('ME')
  const bottomRef = useRef<HTMLDivElement>(null)
  const inputRef = useRef<HTMLInputElement>(null)

  useEffect(() => {
    const email = localStorage.getItem('userEmail') || ''
    if (email) setUserInitials(email.split('@')[0].slice(0, 2).toUpperCase())

    try {
      const saved = localStorage.getItem('fintrack_chat_history')
      const parsed: Message[] = saved ? JSON.parse(saved) : []

      if (parsed.length > 0) {
        // restore real conversation turns as display messages
        // prepend welcome message for display only
        setMessages([...WELCOME_MESSAGE as Message[], ...parsed])
        setApiHistory(parsed)
      } else {
        setMessages(WELCOME_MESSAGE as Message[])
        setApiHistory([])
      }
    } catch {
      setMessages(WELCOME_MESSAGE as Message[])
      setApiHistory([])
    }
  }, [])

  // persist only real conversation turns
  useEffect(() => {
    if (apiHistory.length === 0) return
    localStorage.setItem('fintrack_chat_history', JSON.stringify(apiHistory))
  }, [apiHistory])

  // auto-scroll
  useEffect(() => {
    bottomRef.current?.scrollIntoView({ behavior: 'smooth' })
  }, [messages, loading])

  async function sendMessage(text: string) {
    const trimmed = text.trim()
    if (!trimmed || loading) return

    const userMsg: Message = { role: 'user', content: trimmed }
    setMessages(prev => [...prev, userMsg])
    setInput('')
    setLoading(true)

    try {
      const { data } = await api.post('/api/chat', {
        message: trimmed,
        history: apiHistory,
      })

      const assistantMsg: Message = { role: 'assistant', content: data.message }
      setMessages(prev => [...prev, assistantMsg])

      setApiHistory(prev => [
        ...prev,
        { role: 'user', content: trimmed },
        { role: 'assistant', content: data.message },
      ])
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

  function clearChat() {
    localStorage.removeItem('fintrack_chat_history')
    setMessages(WELCOME_MESSAGE as Message[])
    setApiHistory([])
  }

  function handleKeyDown(e: React.KeyboardEvent<HTMLInputElement>) {
    if (e.key === 'Enter' && !e.shiftKey) {
      e.preventDefault()
      sendMessage(input)
    }
  }

  return (
    <div className="grid gap-5 p-4 md:gap-6 md:p-6 lg:p-8" style={{ height: '100%' }}>

      {/* Header */}
      <div className="flex items-end justify-between">
        <div className="grid gap-1">
          <h1 className="text-4xl font-black tracking-tight text-white">AI Chat</h1>
          <p className="text-gray-500 font-mono text-sm">// ask anything about your finances</p>
        </div>
        <button
          onClick={clearChat}
          className="text-gray-600 hover:text-red-400 transition-colors font-mono text-xs pb-1"
        >
          clear chat
        </button>
      </div>

      {/* Suggested questions */}
      <div className="grid gap-3">
        <span className="text-gray-600 font-mono text-xs uppercase tracking-widest">Suggested Questions</span>
        <div className="flex flex-wrap gap-2">
          {SUGGESTIONS.map(s => (
            <button
              key={s}
              onClick={() => { setInput(s); inputRef.current?.focus() }}
              className="px-3 py-1 rounded-full border border-[#2a2a2a] text-gray-400 text-sm hover:border-green-500/50 hover:text-green-400 transition-colors"
            >
              {s}
            </button>
          ))}
        </div>
      </div>

      {/* Chat card */}
      <div
        className="flex flex-col bg-[#111] rounded-2xl border border-[#2a2a2a] overflow-hidden min-h-[400px] h-[calc(100vh-400px)] lg:h-[calc(100vh-480px)]"
      >

        {/* Messages */}
        <div className="flex-1 overflow-y-auto p-5 grid gap-4 content-start">
          {messages.map((m, i) => (
            <div
              key={i}
              className={`flex items-start gap-3 ${m.role === 'user' ? 'justify-end' : ''}`}
            >
              {m.role === 'assistant' && (
                <>
                  <div className="grid place-items-center w-8 h-8 rounded-full bg-green-600 shrink-0 mt-0.5">
                    <AIIcon />
                  </div>
                  <div className="bg-[#1a3320] border border-green-900/40 rounded-2xl rounded-tl-sm px-4 py-3 max-w-[80%]">
                    <p className="text-gray-100 text-sm leading-relaxed whitespace-pre-line">
                      {renderContent(m.content)}
                    </p>
                  </div>
                </>
              )}

              {m.role === 'user' && (
                <>
                  <div className="bg-[#1a1a1a] border border-[#2a2a2a] rounded-2xl rounded-tr-sm px-4 py-3 max-w-[80%]">
                    <p className="text-white text-sm leading-relaxed">{m.content}</p>
                  </div>
                  <div className="grid place-items-center w-8 h-8 rounded-full bg-[#2a2a2a] text-white text-xs font-bold shrink-0 mt-0.5">
                    {userInitials}
                  </div>
                </>
              )}
            </div>
          ))}

          {/* Typing indicator */}
          {loading && (
            <div className="flex items-start gap-3">
              <div className="grid place-items-center w-8 h-8 rounded-full bg-green-600 shrink-0">
                <AIIcon />
              </div>
              <div className="bg-[#1a3320] border border-green-900/40 rounded-2xl rounded-tl-sm px-5 py-4">
                <div className="flex gap-1.5 items-center">
                  <div className="w-1.5 h-1.5 rounded-full bg-green-400 animate-bounce [animation-delay:0ms]" />
                  <div className="w-1.5 h-1.5 rounded-full bg-green-400 animate-bounce [animation-delay:150ms]" />
                  <div className="w-1.5 h-1.5 rounded-full bg-green-400 animate-bounce [animation-delay:300ms]" />
                </div>
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
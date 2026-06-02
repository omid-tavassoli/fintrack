import Link from 'next/link'
import BanksCarousel from '@/components/BanksCarousel'
import DemoButton from '@/components/DemoButton'

const BANKS = ['Deutsche Bank', 'Postbank', 'Sparkasse', 'Commerzbank', 'HypoVereinsbank', 'Raiffeisenbank', 'Volksbank', 'Deutsche Bank', 'ING', 'ING', 'DKB', 'Revolut', 'Comdirect', 'Consorsbank', 'N26', 'Vivid Money',' Tomorrow']


const FEATURES = [
  {
    icon: (
      <svg width="22" height="22" viewBox="0 0 16 16" fill="none">
        <path d="M8 11V3" stroke="#4ade80" strokeWidth="1.5" strokeLinecap="round" />
        <path d="M5 6l3-3 3 3" stroke="#4ade80" strokeWidth="1.5" strokeLinecap="round" strokeLinejoin="round" />
        <path d="M2 13h12" stroke="#4ade80" strokeWidth="1.5" strokeLinecap="round" />
      </svg>
    ),
    title: 'PDF Upload',
    desc: 'Drop any German bank statement. Gemini Vision extracts every transaction in a single API call.',
  },
  {
    icon: (
      <svg width="22" height="22" viewBox="0 0 16 16" fill="none">
        <path d="M8 2C8 4.5 5.5 7 3 7C5.5 7 8 9.5 8 12C8 9.5 10.5 7 13 7C10.5 7 8 4.5 8 2Z" fill="#4ade80" />
      </svg>
    ),
    title: '98%+ AI Accuracy',
    desc: 'Hybrid rule engine + Gemini fallback. Every correction you make trains a rule — the AI is needed less over time.',
  },
  {
    icon: (
      <svg width="22" height="22" viewBox="0 0 16 16" fill="none">
        <path d="M8 1L1 14h14L8 1z" stroke="#fbbf24" strokeWidth="1.2" strokeLinejoin="round" fill="#fbbf24" fillOpacity="0.12" />
        <path d="M8 5.5v4" stroke="#fbbf24" strokeWidth="1.4" strokeLinecap="round" />
        <circle cx="8" cy="11.5" r="0.8" fill="#fbbf24" />
      </svg>
    ),
    title: 'Anomaly Detection',
    desc: 'Z-score analysis flags unusual transactions automatically — like a €41 restaurant bill when you normally spend €12.',
  },
  {
    icon: (
      <svg width="22" height="22" viewBox="0 0 16 16" fill="none">
        <circle cx="8" cy="8" r="7" stroke="#60a5fa" strokeWidth="1.5" />
        <path d="M5 8h6M8 5v6" stroke="#60a5fa" strokeWidth="1.3" strokeLinecap="round" />
      </svg>
    ),
    title: 'Natural Language Queries',
    desc: 'Ask "How much did I spend on food in October?" — the engine generates SQL from plain text and returns a direct answer.',
  },
  {
    icon: (
      <svg width="22" height="22" viewBox="0 0 16 16" fill="none">
        <rect x="1" y="1" width="14" height="10" rx="2" stroke="#4ade80" strokeWidth="1.5" />
        <path d="M5 15l2-4h2l2 4" stroke="#4ade80" strokeWidth="1.5" strokeLinejoin="round" />
      </svg>
    ),
    title: 'AI Chat Assistant',
    desc: 'A conversational advisor with full access to your transaction history. Answers follow up questions in context.',
  },
  {
    icon: (
      <svg width="22" height="22" viewBox="0 0 16 16" fill="none">
        <rect x="1" y="4" width="14" height="10" rx="1.5" stroke="#4ade80" strokeWidth="1.4" />
        <path d="M1 7h14" stroke="#4ade80" strokeWidth="1.4" />
        <rect x="10" y="8.5" width="3.5" height="2.5" rx="1.25" stroke="#4ade80" strokeWidth="1.2" />
        <path d="M3 9.5h4M3 11.5h2.5" stroke="#4ade80" strokeWidth="1.1" strokeLinecap="round" />
      </svg>
    ),
    title: 'Budget Tracking',
    desc: 'Set monthly limits per category. Visual progress bars turn amber and red as you approach or exceed your budget.',
  },
  {
    icon: (
      <svg width="22" height="22" viewBox="0 0 16 16" fill="none">
        <path d="M2 12L5.5 7l3 3L11 5l3 5" stroke="#4ade80" strokeWidth="1.5" strokeLinecap="round" strokeLinejoin="round" />
      </svg>
    ),
    title: 'Spending Analytics',
    desc: 'Monthly bar charts, category donut breakdowns, and 6-month trend views — all from your uploaded statements.',
  },
  {
    icon: (
      <svg width="22" height="22" viewBox="0 0 16 16" fill="none">
        <rect x="2" y="2" width="12" height="12" rx="2" stroke="#a78bfa" strokeWidth="1.5" />
        <path d="M5 8h2M9 8h2M8 5v2M8 9v2" stroke="#a78bfa" strokeWidth="1.3" strokeLinecap="round" />
      </svg>
    ),
    title: 'No Bank Access Required',
    desc: 'Works entirely from the PDF you already receive. No credentials, no open banking, no third-party connections.',
  },
]

const AI_LAYERS = [
  {
    num: '01',
    title: 'PDF Extraction',
    sub: 'Gemini Vision',
    desc: 'One API call processes an entire bank statement. Gemini Vision reads the raw PDF and returns structured transaction data — date, amount, counterpart, description.',
    color: 'text-green-400',
    border: 'border-green-500/20',
    bg: 'bg-green-500/5',
  },
  {
    num: '02',
    title: 'Categorization',
    sub: 'Rule Cache + LLM Fallback',
    desc: 'Known merchants are matched instantly by a rule cache that learns from every correction you make. Unknown transactions fall through to Gemini. Over time, fewer AI calls are needed.',
    color: 'text-blue-400',
    border: 'border-blue-500/20',
    bg: 'bg-blue-500/5',
  },
  {
    num: '03',
    title: 'NL Query Engine',
    sub: 'Text → SQL → Answer',
    desc: 'A plain-language question becomes a SQL query via Gemini, runs against your real transaction data, and returns a precise answer — not a vague summary.',
    color: 'text-amber-400',
    border: 'border-amber-500/20',
    bg: 'bg-amber-500/5',
  },
  {
    num: '04',
    title: 'Chat Assistant',
    sub: 'Conversational Finance Advisor',
    desc: 'Full transaction context is injected into every chat session. Ask follow-up questions, compare months, get advice — all grounded in your actual spending data.',
    color: 'text-purple-400',
    border: 'border-purple-500/20',
    bg: 'bg-purple-500/5',
  },
]

const STEPS = [
  { n: '1', title: 'Upload', desc: 'Drop your monthly bank PDF — the same one your bank emails you.' },
  { n: '2', title: 'Extract', desc: 'Gemini Vision parses every transaction from the raw PDF in seconds.' },
  { n: '3', title: 'Categorize', desc: 'Rules handle known merchants instantly. AI covers the rest with 98%+ accuracy.' },
  { n: '4', title: 'Analyze', desc: 'Explore charts, set budgets, detect anomalies, and chat with your data.' },
]

const STACK = ['Spring Boot 3', 'PostgreSQL', 'Gemini 2.5 Flash', 'Next.js', 'Docker']

export default function LandingPage() {
  return (
    <div className="min-h-screen bg-[#0a0a0a] text-white">

      {/* ── Navbar ──────────────────────────────────────────────────────────── */}
      <nav className="sticky top-0 z-30 flex items-center justify-between px-6 py-4 bg-[#0a0a0a]/80 backdrop-blur border-b border-[#1a1a1a]">
        <span className="text-2xl font-serif">
          <span className="text-green-400">Fin</span>Track
        </span>
        <div className="flex items-center gap-3">
          <Link href="/login" className="px-4 py-2 rounded-full border border-[#2a2a2a] text-gray-400 text-sm hover:text-white hover:border-[#444] transition-colors">
            Sign In
          </Link>
          <Link href="/login" className="px-4 py-2 rounded-full bg-green-500 text-black text-sm font-semibold hover:bg-green-400 transition-colors">
            Get Started
          </Link>
        </div>
      </nav>

      {/* ── Hero ────────────────────────────────────────────────────────────── */}
      <section className="grid place-items-center text-center px-6 py-28 md:py-16">
        <div className="grid gap-6 max-w-3xl">
          <p className="text-gray-500 font-mono text-md">// AI-powered finance tracker</p>
          <h1 className="text-5xl font-black tracking-tight leading-tight md:text-7xl">
            Start looking<br />
            <span className="text-green-400">where your money goes.</span>
            <span className="text-green-400"></span>
          </h1>
          <p className="text-gray-400 text-lg leading-relaxed max-w-xl mx-auto">
            <span className="text-green-400">Upload</span> your bank statements. FinTrack uses AI to <span className="text-green-400">extract</span> every transaction,
            <span className="text-green-400">categorize</span> spending, <span className="text-green-400">detect</span> anomalies, and <span className="text-green-400">answer</span> any question about your finances —
            <span className="text-yellow-400">no bank credentials required.</span>
          </p>

          {/* CTAs */}
          <div className="flex flex-wrap items-center justify-center gap-3 mt-2">
            <DemoButton className="px-7 py-3.5 rounded-full bg-green-500 text-black font-semibold text-base hover:bg-green-400 active:bg-green-600 transition-colors disabled:opacity-60" />
            <Link
              href="/login"
              className="px-7 py-3.5 rounded-full border border-[#2a2a2a] text-gray-300 text-base hover:border-[#444] hover:text-white transition-colors"
            >
              Sign Up Free
            </Link>
          </div>

        </div>
      </section>

      {/* ── Banks carousel ──────────────────────────────────────────────────── */}
      <BanksCarousel banks={BANKS} />

      {/* ── Stats bar ───────────────────────────────────────────────────────── */}
      <section className="border-y border-[#1a1a1a] bg-[#0d0d0d]">
        <div className="max-w-4xl mx-auto grid grid-cols-2 md:grid-cols-4">
          {[
            { val: '98%+', label: 'categorization accuracy' },
            { val: '17+',   label: 'Banks supported in germany' },
            { val: 'Multiple',    label: 'AI engines working together' },
            { val: 'NO',    label: 'bank credentials needed' },
          ].map(s => (
            <div key={s.label} className="grid gap-1 text-center py-8 px-4 border-r border-[#1a1a1a] last:border-0">
              <span className="font-mono text-3xl font-bold text-green-400">{s.val}</span>
              <span className="text-gray-600 font-mono text-xs">{s.label}</span>
            </div>
          ))}
        </div>
      </section>

      {/* ── How it works ────────────────────────────────────────────────────── */}
      <section className="max-w-5xl mx-auto px-6 py-24">
        <div className="grid gap-3 mb-14">
          <p className="text-gray-600 font-mono text-md uppercase tracking-widest">How it works</p>
          <h2 className="text-4xl font-black tracking-tight">Four steps from PDF to insight.</h2>
        </div>

        <div className="grid grid-cols-1 gap-4 md:grid-cols-4">
          {STEPS.map((step, i) => (
            <div key={step.n} className="relative grid gap-3 bg-[#111] border border-[#2a2a2a] rounded-2xl p-5">
              {/* Connector line */}
              {i < STEPS.length - 1 && (
                <div className="hidden md:block absolute top-8 -right-2 w-4 h-px bg-[#2a2a2a] z-10" />
              )}
              <span className="font-mono text-4xl font-bold text-green-500/30">{step.n}</span>
              <span className="text-white font-semibold">{step.title}</span>
              <span className="text-gray-500 text-sm leading-relaxed">{step.desc}</span>
            </div>
          ))}
        </div>
      </section>

      {/* ── Features ────────────────────────────────────────────────────────── */}
      <section className="max-w-5xl mx-auto px-6 py-10 pb-24">
        <div className="grid gap-3 mb-14">
          <p className="text-gray-600 font-mono text-md uppercase tracking-widest">Features</p>
          <h2 className="text-4xl font-black tracking-tight">Everything you need.<br />Nothing you don't.</h2>
        </div>

        <div className="grid grid-cols-1 gap-4 sm:grid-cols-2 lg:grid-cols-4">
          {FEATURES.map(f => (
            <div key={f.title} className="grid gap-3 bg-[#111] border border-[#2a2a2a] rounded-2xl p-5 hover:border-[#333] transition-colors">
              <div className="w-9 h-9 grid place-items-center rounded-xl bg-[#1a1a1a]">
                {f.icon}
              </div>
              <span className="text-white font-semibold text-sm">{f.title}</span>
              <span className="text-gray-500 text-sm leading-relaxed">{f.desc}</span>
            </div>
          ))}
        </div>
      </section>

      {/* ── AI deep-dive ────────────────────────────────────────────────────── */}
      <section className="border-t border-[#1a1a1a] bg-[#0d0d0d]">
        <div className="max-w-5xl mx-auto px-6 py-24">
          <div className="grid gap-3 mb-14">
            <p className="text-gray-600 font-mono text-md uppercase tracking-widest">The AI story</p>
            <h2 className="text-4xl font-black tracking-tight">
              Not one AI.<br />
              <span className="text-green-400">Four working together.</span>
            </h2>
            <p className="text-gray-500 max-w-xl leading-relaxed">
              Each layer is specialized. The rule cache handles what it knows. Gemini handles the unknown.
              Nothing is over-engineered — every AI call earns its cost.
            </p>
          </div>

          <div className="grid grid-cols-1 gap-4 md:grid-cols-2">
            {AI_LAYERS.map(layer => (
              <div key={layer.num} className={`grid gap-3 rounded-2xl border p-6 ${layer.border} ${layer.bg}`}>
                <div className="flex items-center gap-3">
                  <span className={`font-mono text-xs font-bold ${layer.color}`}>{layer.num}</span>
                  <div>
                    <p className="text-white font-semibold text-sm">{layer.title}</p>
                    <p className={`font-mono text-xs ${layer.color}`}>{layer.sub}</p>
                  </div>
                </div>
                <p className="text-gray-400 text-sm leading-relaxed">{layer.desc}</p>
              </div>
            ))}
          </div>
        </div>
      </section>

      {/* ── Tech stack ──────────────────────────────────────────────────────── */}
      <section className="border-t border-[#1a1a1a]">
        <div className="max-w-5xl mx-auto px-6 py-16 flex flex-wrap items-center justify-between gap-6">
          <p className="text-gray-600 font-mono text-md uppercase tracking-widest">Tech stack</p>
          <div className="flex flex-wrap gap-2">
            {STACK.map(t => (
              <span key={t} className="px-3 py-1.5 rounded-lg border border-[#222] text-gray-500 font-mono text-xs">
                {t}
              </span>
            ))}
          </div>
        </div>
      </section>

      {/* ── Final CTA ───────────────────────────────────────────────────────── */}
      <section className="border-t border-[#1a1a1a] bg-[#0d0d0d]">
        <div className="max-w-2xl mx-auto px-6 py-28 grid gap-6 text-center">
          <h2 className="text-4xl font-black tracking-tight md:text-5xl">
            Your finances.<br />
            <span className="text-green-400">Finally clear.</span>
          </h2>
          <p className="text-gray-500 leading-relaxed">
            <span className="text-red-400">No</span> subscription. <span className="text-red-400">No</span> bank access. <span className="text-red-400">No</span> setup beyond uploading a PDF.
            Try the demo account to explore with real-looking data.
          </p>
          <div className="flex flex-wrap justify-center gap-3">
            <DemoButton className="px-8 py-3.5 rounded-full bg-green-500 text-black font-semibold text-base hover:bg-green-400 transition-colors disabled:opacity-60" />
            <Link
              href="/login"
              className="px-8 py-3.5 rounded-full border border-[#2a2a2a] text-gray-300 text-base hover:border-[#444] hover:text-white transition-colors"
            >
              Create Account
            </Link>
          </div>
        </div>
      </section>

      {/* ── Footer ──────────────────────────────────────────────────────────── */}
      <footer className="border-t border-[#1a1a1a] px-6 py-8 flex items-center justify-between flex-wrap gap-4">
        <span className="text-xl font-serif">
          <span className="text-green-400">Fin</span>Track
        </span>
        <p className="text-gray-700 font-mono text-xs">// AI-powered finance tracker · self-hosted</p>
      </footer>

    </div>
  )
}

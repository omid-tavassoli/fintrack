// Shared nav config and icon renderer used by Sidebar (desktop) and MobileHeader (mobile/tablet)

export const NAV_ITEMS = [
  { href: '/dashboard',    label: 'Dashboard',    icon: 'grid'   },
  { href: '/transactions', label: 'Transactions', icon: 'list'   },
  { href: '/upload',       label: 'Upload',       icon: 'upload' },
  { href: '/chat',         label: 'AI Chat',      icon: 'chat'   },
  { href: '/budgets',      label: 'Budgets',      icon: 'budget' },
]

export function NavIcon({ type, active, size = 16, color }: {
  type: string
  active: boolean
  size?: number
  color?: string
}) {
  const c = color ?? (active ? '#4ade80' : '#6b7280')
  const s = size
  if (type === 'grid') return (
    <svg width={s} height={s} viewBox="0 0 16 16" fill="none">
      <rect x="1" y="1" width="6" height="6" rx="1.2" fill={c} />
      <rect x="9" y="1" width="6" height="6" rx="1.2" fill={c} />
      <rect x="1" y="9" width="6" height="6" rx="1.2" fill={c} />
      <rect x="9" y="9" width="6" height="6" rx="1.2" fill={c} />
    </svg>
  )
  if (type === 'list') return (
    <svg width={s} height={s} viewBox="0 0 16 16" fill="none">
      <circle cx="2.5" cy="4"  r="1.5" fill={c} />
      <rect x="6" y="3"  width="9" height="2" rx="1" fill={c} />
      <circle cx="2.5" cy="8"  r="1.5" fill={c} />
      <rect x="6" y="7"  width="9" height="2" rx="1" fill={c} />
      <circle cx="2.5" cy="12" r="1.5" fill={c} />
      <rect x="6" y="11" width="9" height="2" rx="1" fill={c} />
    </svg>
  )
  if (type === 'upload') return (
    <svg width={s} height={s} viewBox="0 0 16 16" fill="none">
      <path d="M8 11V3" stroke={c} strokeWidth="1.5" strokeLinecap="round" />
      <path d="M5 6l3-3 3 3" stroke={c} strokeWidth="1.5" strokeLinecap="round" strokeLinejoin="round" />
      <path d="M2 13h12" stroke={c} strokeWidth="1.5" strokeLinecap="round" />
    </svg>
  )
  if (type === 'chat') return (
    <svg width={s} height={s} viewBox="0 0 16 16" fill="none">
      {/* Speech bubble */}
      <path
        d="M2 1h12a1.5 1.5 0 0 1 1.5 1.5v9A1.5 1.5 0 0 1 14 13H9l-3 3v-3H2a1.5 1.5 0 0 1-1.5-1.5v-9A1.5 1.5 0 0 1 2 1z"
        stroke={c} strokeWidth="1.3" strokeLinejoin="round"
      />
      {/*
        Gemini 4-point star — 4 cubic bezier curves, each concave between tips.
        Center (8, 7), radius 2.8. Control points at half-radius create the inward curve.
        M top → C ctrl ctrl left → C ctrl ctrl bottom → C ctrl ctrl right → C ctrl ctrl top Z
      */}
      <path
        d="M8 2C8 4.5 5.5 7 3 7C5.5 7 8 9.5 8 12C8 9.5 10.5 7 13 7C10.5 7 8 4.5 8 2Z"
        fill={c}
      />
    </svg>
  )
  if (type === 'budget') return (
    <svg width={s} height={s} viewBox="0 0 16 16" fill="none">
      {/* Wallet body */}
      <rect x="1" y="4" width="14" height="10" rx="1.5" stroke={c} strokeWidth="1.4" />
      {/* Wallet flap/top fold */}
      <path d="M1 7h14" stroke={c} strokeWidth="1.4" />
      {/* Coin pocket */}
      <rect x="10" y="8.5" width="3.5" height="2.5" rx="1.25" stroke={c} strokeWidth="1.2" />
      {/* Card lines on left */}
      <path d="M3 9.5h4M3 11.5h2.5" stroke={c} strokeWidth="1.1" strokeLinecap="round" />
    </svg>
  )
  return null
}

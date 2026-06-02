'use client'

import Link from 'next/link'
import { usePathname } from 'next/navigation'
import { useEffect, useState } from 'react'
import { NAV_ITEMS, NavIcon } from './NavIcon'

export default function Sidebar() {
  const pathname = usePathname()
  const [email, setEmail] = useState('')

  useEffect(() => {
    setEmail(localStorage.getItem('userEmail') || '')
  }, [])

  const displayName = email
    ? email.split('@')[0].replace('.', ' ').replace(/\b\w/g, (c) => c.toUpperCase())
    : 'User'
  const initials = displayName.split(' ').map((s: string) => s[0] ?? '').join('').toUpperCase().slice(0, 2)

  return (
    // hidden on mobile/tablet — MobileHeader takes over below lg
    <aside className="hidden lg:grid grid-rows-[auto_1fr_auto] h-screen sticky top-0 bg-[#0d0d0d] border-r border-[#1e1e1e] px-4 py-6">

      {/* Logo */}
      <div className="px-2 mb-8">
        <span className="text-2xl font-serif">
          <span className="text-green-400">Fin</span>
          <span className="text-white">Track</span>
        </span>
      </div>

      {/* Navigation */}
      <nav className="grid gap-1 content-start">
        {NAV_ITEMS.map(({ href, label, icon }) => {
          const active = pathname === href
          return (
            <Link
              key={href}
              href={href}
              className={`flex items-center gap-3 px-3 py-2.5 rounded-xl text-sm font-medium transition-colors ${
                active
                  ? 'bg-[#1a3320] text-green-400'
                  : 'text-gray-500 hover:text-white hover:bg-[#1a1a1a]'
              }`}
            >
              <NavIcon type={icon} active={active} />
              {label}
            </Link>
          )
        })}
      </nav>

      {/* User */}
      <div className="grid grid-cols-[auto_1fr] items-center gap-3 pt-4 border-t border-[#1e1e1e]">
        <div className="grid place-items-center w-9 h-9 rounded-full bg-green-600 text-black text-xs font-bold shrink-0">
          {initials || '?'}
        </div>
        <div className="grid min-w-0">
          <span className="text-white text-sm font-medium truncate">{displayName}</span>
          <span className="text-gray-500 text-xs truncate">{email}</span>
        </div>
      </div>

    </aside>
  )
}

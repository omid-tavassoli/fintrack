'use client'

import Link from 'next/link'
import { usePathname } from 'next/navigation'
import { useEffect, useState } from 'react'
import { NAV_ITEMS, NavIcon } from './NavIcon'

export default function MobileHeader() {
  const pathname = usePathname()
  const [email, setEmail] = useState('')

  useEffect(() => {
    setEmail(localStorage.getItem('userEmail') || '')
  }, [])

  const initials = email.split('@')[0].slice(0, 2).toUpperCase() || '?'

  return (
    <>
      {/* Top bar */}
      <header className="lg:hidden sticky top-0 z-20 flex items-center justify-between px-5 py-3.5 bg-[#0d0d0d] border-b border-[#1e1e1e]">
        <span className="text-xl font-serif">
          <span className="text-green-400">Fin</span>
          <span className="text-white">Track</span>
        </span>
        <div className="grid place-items-center w-8 h-8 rounded-full bg-green-600 text-black text-xs font-bold">
          {initials}
        </div>
      </header>

      {/* Bottom nav */}
      <nav
        className="lg:hidden fixed bottom-0 inset-x-0 z-20 flex items-end bg-[#0d0d0d]"
        style={{ paddingBottom: 'env(safe-area-inset-bottom)' }}
      >
        {/* Split border: gap = circle width (4rem = w-16), centered at 50% */}
        <div className="absolute top-0 inset-x-0 h-px flex pointer-events-none" aria-hidden="true">
          <div className="bg-[#1e1e1e]" style={{ width: 'calc(50% - 1.5rem)' }} />
          <div style={{ width: '3rem' }} />
          <div className="flex-1 bg-[#1e1e1e]" />
        </div>

        {NAV_ITEMS.map(({ href, label, icon }) => {
          const active = pathname === href

          if (icon === 'upload') {
            return (
              <Link
                key={href}
                href={href}
                className="flex flex-col items-center gap-2 flex-1 -translate-y-4"
              >
                <div className={`grid place-items-center w-12 h-12 rounded-full shadow-xl transition-all ${
                  active
                    ? 'bg-green-400 shadow-green-500/50'
                    : 'bg-green-500 hover:bg-green-400 shadow-green-500/30'
                }`}>
                  <NavIcon type={icon} active={true} size={18} color="#000000" />
                </div>
                <span className={`text-xs font-medium pb-3 ${active ? 'text-green-400' : 'text-gray-500'}`}>
                  {label}
                </span>
              </Link>
            )
          }

          return (
            <Link
              key={href}
              href={href}
              className={`flex flex-col items-center gap-2 flex-1 pt-4 pb-3 transition-colors ${
                active ? 'text-green-400' : 'text-gray-500'
              }`}
            >
              <NavIcon type={icon} active={active} size={22} />
              <span className="text-xs font-medium">{label}</span>
            </Link>
          )
        })}
      </nav>
    </>
  )
}

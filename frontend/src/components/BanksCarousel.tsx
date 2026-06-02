'use client'

import { motion } from 'framer-motion'

export default function BanksCarousel({ banks }: { banks: string[] }) {
  return (
    <div className="relative overflow-hidden border-y border-[#1a1a1a] py-4 bg-[#0d0d0d]">
      {/* Fade edges */}
      <div className="pointer-events-none absolute inset-y-0 left-0 w-24 z-10 bg-gradient-to-r from-[#0d0d0d] to-transparent" />
      <div className="pointer-events-none absolute inset-y-0 right-0 w-24 z-10 bg-gradient-to-l from-[#0d0d0d] to-transparent" />

      <motion.div
        className="flex gap-3 w-max"
        animate={{ x: ['-50%', '0%'] }}
        transition={{ duration: 25, ease: 'linear', repeat: Infinity, repeatType: 'loop' }}
      >
        {[...banks, ...banks].map((bank, i) => (
          <span
            key={i}
            className="px-4 py-2 rounded-full border border-[#2a2a2a] text-gray-500 font-mono text-sm whitespace-nowrap"
          >
            {bank}
          </span>
        ))}
      </motion.div>
    </div>
  )
}

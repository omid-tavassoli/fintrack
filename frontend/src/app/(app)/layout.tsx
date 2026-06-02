import AuthGuard from '@/components/AuthGuard'
import Sidebar from '@/components/Sidebar'
import MobileHeader from '@/components/MobileHeader'

export default function AppLayout({ children }: { children: React.ReactNode }) {
  return (
    <AuthGuard>
      {/*
        grid-cols-1         → mobile/tablet: full width, sidebar hidden
        lg:grid-cols-[220px_1fr] → desktop: sidebar + content side by side
      */}
      <div className="grid grid-cols-1 lg:grid-cols-[220px_1fr] min-h-screen bg-[#0a0a0a]">
        <Sidebar />
        <div className="flex flex-col min-h-screen lg:min-h-0">
          <MobileHeader />
          {/* pb-24 on mobile reserves space above the fixed bottom nav (extra for raised upload button) */}
          <main className="flex-1 overflow-auto pb-24 lg:pb-0">{children}</main>
        </div>
      </div>
    </AuthGuard>
  )
}

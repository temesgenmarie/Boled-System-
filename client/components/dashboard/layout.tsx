"use client"

import type React from "react"
import { useState } from "react"
import Link from "next/link"
import { usePathname } from "next/navigation"
import { Menu, X, LogOut, Settings, Users, MessageSquare, BarChart3, ChevronRight } from "lucide-react"
import { Button } from "@/components/ui/button"
import { useAuth } from "@/lib/auth-context"

interface DashboardLayoutProps {
  children: React.ReactNode
}

export default function DashboardLayout({ children }: DashboardLayoutProps) {
  const [sidebarOpen, setSidebarOpen] = useState(true)
  const { orgName, logout } = useAuth()
  const pathname = usePathname()

  const navItems = [
    { href: "/dashboard", label: "Overview", icon: BarChart3 },
    { href: "/dashboard/members", label: "Members", icon: Users },
    { href: "/dashboard/messages", label: "Messages", icon: MessageSquare },
    { href: "/dashboard/settings", label: "Settings", icon: Settings },
  ]

  const isActive = (href: string) => pathname === href

  return (
    <div className="flex h-screen bg-background">
      <aside
        className={`${
          sidebarOpen ? "w-64" : "w-20"
        } bg-card border-r border-border transition-all duration-300 flex flex-col shadow-sm`}
      >
        <div className="p-4 border-b border-border flex items-center justify-between">
          {sidebarOpen && (
            <div className="flex items-center gap-2">
              <div className="w-8 h-8 rounded-lg bg-primary/10 flex items-center justify-center">
                <div className="w-4 h-4 bg-primary rounded-sm"></div>
              </div>
              <h1 className="font-heading font-bold text-lg truncate">{orgName}</h1>
            </div>
          )}
          <button
            onClick={() => setSidebarOpen(!sidebarOpen)}
            className="p-1 hover:bg-background rounded-lg transition-colors"
          >
            {sidebarOpen ? <X size={20} /> : <Menu size={20} />}
          </button>
        </div>

        <nav className="flex-1 p-4 space-y-2">
          {navItems.map((item) => (
            <Link
              key={item.href}
              href={item.href}
              className={`flex items-center gap-3 px-4 py-2.5 rounded-lg transition-all duration-200 ${
                isActive(item.href) ? "bg-primary/10 text-primary font-medium" : "text-foreground hover:bg-background"
              }`}
            >
              <item.icon size={20} />
              {sidebarOpen && (
                <>
                  <span className="flex-1">{item.label}</span>
                  {isActive(item.href) && <ChevronRight size={16} />}
                </>
              )}
            </Link>
          ))}
        </nav>

        <div className="p-4 border-t border-border">
          <Button
            onClick={logout}
            variant="outline"
            className="w-full flex items-center gap-2 justify-center hover:bg-destructive/10 hover:text-destructive hover:border-destructive/20 bg-transparent"
          >
            <LogOut size={18} />
            {sidebarOpen && "Logout"}
          </Button>
        </div>
      </aside>

      {/* Main Content */}
      <main className="flex-1 overflow-auto">
        <div className="p-8 max-w-7xl mx-auto">{children}</div>
      </main>
    </div>
  )
}

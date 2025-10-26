"use client"

import type React from "react"

import { createContext, useContext, useEffect, useState } from "react"
import { useRouter } from "next/navigation"

interface AuthContextType {
  isAuthenticated: boolean
  orgId: string | null
  orgName: string | null
  loading: boolean
  logout: () => void
}

const AuthContext = createContext<AuthContextType | undefined>(undefined)

export function AuthProvider({ children }: { children: React.ReactNode }) {
  const [isAuthenticated, setIsAuthenticated] = useState(false)
  const [orgId, setOrgId] = useState<string | null>(null)
  const [orgName, setOrgName] = useState<string | null>(null)
  const [loading, setLoading] = useState(true)
  const router = useRouter()

  useEffect(() => {
    const token = localStorage.getItem("adminToken")
    const storedOrgId = localStorage.getItem("orgId")
    const storedOrgName = localStorage.getItem("orgName")

    if (token && storedOrgId) {
      setIsAuthenticated(true)
      setOrgId(storedOrgId)
      setOrgName(storedOrgName)
    }
    setLoading(false)
  }, [])

  const logout = () => {
    localStorage.removeItem("adminToken")
    localStorage.removeItem("orgId")
    localStorage.removeItem("orgName")
    setIsAuthenticated(false)
    setOrgId(null)
    setOrgName(null)
    router.push("/")
  }

  return (
    <AuthContext.Provider value={{ isAuthenticated, orgId, orgName, loading, logout }}>{children}</AuthContext.Provider>
  )
}

export function useAuth() {
  const context = useContext(AuthContext)
  if (context === undefined) {
    throw new Error("useAuth must be used within AuthProvider")
  }
  return context
}

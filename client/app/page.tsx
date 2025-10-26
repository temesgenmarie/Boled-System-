"use client"

import { useState, useEffect } from "react"
import { useRouter } from "next/navigation"
import LoginForm from "@/components/auth/login-form"

export default function Home() {
  const router = useRouter()
  const [isLoading, setIsLoading] = useState(false)
  const [error, setError] = useState("")

  useEffect(() => {
    const token = localStorage.getItem("adminToken")
    if (token) {
      router.push("/dashboard")
    }
  }, [router])

  const handleLogin = async (email: string, password: string) => {
    setIsLoading(true)
    setError("")
    try {
      const response = await fetch("/api/auth/login", {
        method: "POST",
        headers: { "Content-Type": "application/json" },
        body: JSON.stringify({ email, password }),
      })

      if (response.ok) {
        const data = await response.json()
        localStorage.setItem("adminToken", data.token)
        localStorage.setItem("orgId", data.orgId)
        localStorage.setItem("orgName", data.orgName)
        router.push("/dashboard")
      } else {
        setError("Invalid credentials. Please try again.")
      }
    } catch (error) {
      console.error("Login error:", error)
      setError("Login failed. Please try again.")
    } finally {
      setIsLoading(false)
    }
  }

  return (
    <div className="min-h-screen flex items-center justify-center bg-gradient-to-br from-background via-background to-slate-50 dark:to-slate-900 p-4">
      <LoginForm onSubmit={handleLogin} isLoading={isLoading} error={error} />
    </div>
  )
}

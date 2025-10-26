"use client"

import { useState } from "react"
import { useRouter } from "next/navigation"
import LoginForm from "@/components/auth/login-form"

export default function Home() {
  const router = useRouter()
  const [isLoading, setIsLoading] = useState(false)

  const handleLogin = async (email: string, password: string) => {
    setIsLoading(true)
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
        alert("Invalid credentials")
      }
    } catch (error) {
      console.error("Login error:", error)
      alert("Login failed")
    } finally {
      setIsLoading(false)
    }
  }

  return (
    <div className="min-h-screen flex items-center justify-center bg-background">
      <LoginForm onSubmit={handleLogin} isLoading={isLoading} />
    </div>
  )
}

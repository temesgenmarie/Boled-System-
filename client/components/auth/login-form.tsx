"use client"

import type React from "react"
import { useState } from "react"
import { Button } from "@/components/ui/button"
import { Input } from "@/components/ui/input"
import { Card, CardContent, CardDescription, CardHeader, CardTitle } from "@/components/ui/card"
import { AlertCircle } from "lucide-react"

interface LoginFormProps {
  onSubmit: (email: string, password: string) => void
  isLoading: boolean
  error?: string
}

export default function LoginForm({ onSubmit, isLoading, error }: LoginFormProps) {
  const [email, setEmail] = useState("")
  const [password, setPassword] = useState("")

  const handleSubmit = (e: React.FormEvent) => {
    e.preventDefault()
    if (email && password) {
      onSubmit(email, password)
    }
  }

  return (
    <div className="w-full max-w-md space-y-6">
      <div className="text-center space-y-2">
        <div className="inline-flex items-center justify-center w-12 h-12 rounded-lg bg-primary/10">
          <div className="w-6 h-6 bg-primary rounded-md"></div>
        </div>
        <h1 className="text-3xl font-heading font-bold">Admin Portal</h1>
        <p className="text-muted-foreground">Manage your organization with ease</p>
      </div>

      <Card className="border-border bg-card shadow-lg">
        <CardHeader className="space-y-2">
          <CardTitle className="text-2xl font-heading">Welcome Back</CardTitle>
          <CardDescription>Enter your organization credentials to continue</CardDescription>
        </CardHeader>
        <CardContent>
          <form onSubmit={handleSubmit} className="space-y-4">
            {error && (
              <div className="flex items-center gap-2 p-3 rounded-lg bg-destructive/10 border border-destructive/20">
                <AlertCircle className="w-4 h-4 text-destructive flex-shrink-0" />
                <p className="text-sm text-destructive">{error}</p>
              </div>
            )}

            <div className="space-y-2">
              <label htmlFor="email" className="text-sm font-medium">
                Organization Email
              </label>
              <Input
                id="email"
                type="email"
                placeholder="admin@organization.com"
                value={email}
                onChange={(e) => setEmail(e.target.value)}
                required
                disabled={isLoading}
                className="bg-input border-border focus:ring-2 focus:ring-primary/20"
              />
            </div>

            <div className="space-y-2">
              <label htmlFor="password" className="text-sm font-medium">
                Password
              </label>
              <Input
                id="password"
                type="password"
                placeholder="••••••••"
                value={password}
                onChange={(e) => setPassword(e.target.value)}
                required
                disabled={isLoading}
                className="bg-input border-border focus:ring-2 focus:ring-primary/20"
              />
            </div>

            <Button
              type="submit"
              disabled={isLoading || !email || !password}
              className="w-full bg-primary hover:bg-primary/90 text-primary-foreground font-medium h-10"
            >
              {isLoading ? "Signing in..." : "Sign In"}
            </Button>
          </form>

          <div className="mt-6 pt-6 border-t border-border">
            <p className="text-xs text-muted-foreground text-center mb-2">Demo Credentials:</p>
            <div className="space-y-1 text-xs text-muted-foreground text-center">
              <p>
                Email: <span className="font-mono text-foreground">admin@acme.com</span>
              </p>
              <p>
                Password: <span className="font-mono text-foreground">password123</span>
              </p>
            </div>
          </div>
        </CardContent>
      </Card>
    </div>
  )
}

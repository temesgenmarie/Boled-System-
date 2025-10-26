"use client"

import { useEffect, useState } from "react"
import { useRouter } from "next/navigation"
import DashboardLayout from "@/components/dashboard/layout"
import { Card, CardContent, CardDescription, CardHeader, CardTitle } from "@/components/ui/card"
import { Button } from "@/components/ui/button"
import { Input } from "@/components/ui/input"
import { Separator } from "@/components/ui/separator"
import { useAuth } from "@/lib/auth-context"

interface OrgSettings {
  name: string
  email: string
  phone: string
  address: string
}

export default function SettingsPage() {
  const router = useRouter()
  const { isAuthenticated, orgId, orgName, loading: authLoading } = useAuth()
  const [settings, setSettings] = useState<OrgSettings>({
    name: "",
    email: "",
    phone: "",
    address: "",
  })
  const [loading, setLoading] = useState(true)
  const [saving, setSaving] = useState(false)
  const [error, setError] = useState<string | null>(null)
  const [success, setSuccess] = useState<string | null>(null)

  useEffect(() => {
    if (!authLoading && !isAuthenticated) {
      router.push("/")
      return
    }
    if (orgId) {
      fetchSettings()
    }
  }, [isAuthenticated, authLoading, orgId, router])

  const fetchSettings = async () => {
    try {
      setError(null)
      const response = await fetch(`/api/settings?orgId=${orgId}`)
      if (response.ok) {
        const data = await response.json()
        setSettings(data)
      } else {
        setError("Failed to fetch settings")
      }
    } catch (error) {
      console.error("Failed to fetch settings:", error)
      setError("An error occurred while fetching settings")
    } finally {
      setLoading(false)
    }
  }

  const handleSave = async () => {
    setSaving(true)
    setError(null)
    setSuccess(null)
    try {
      const response = await fetch("/api/settings", {
        method: "PUT",
        headers: { "Content-Type": "application/json" },
        body: JSON.stringify({ ...settings, orgId }),
      })

      if (response.ok) {
        setSuccess("Settings saved successfully")
        setTimeout(() => setSuccess(null), 3000)
      } else {
        setError("Failed to save settings")
      }
    } catch (error) {
      console.error("Failed to save settings:", error)
      setError("An error occurred while saving settings")
    } finally {
      setSaving(false)
    }
  }

  if (authLoading) {
    return (
      <DashboardLayout>
        <div className="text-center py-8">Loading...</div>
      </DashboardLayout>
    )
  }

  if (loading) {
    return (
      <DashboardLayout>
        <div className="text-center py-8">Loading settings...</div>
      </DashboardLayout>
    )
  }

  return (
    <DashboardLayout>
      <div className="space-y-6">
        <div>
          <h1 className="text-3xl font-bold">Settings</h1>
          <p className="text-muted-foreground mt-2">Manage your organization settings and profile</p>
        </div>

        {error && (
          <div className="bg-destructive/10 border border-destructive text-destructive px-4 py-3 rounded-lg">
            {error}
          </div>
        )}

        {success && <div className="bg-accent/10 border border-accent text-accent px-4 py-3 rounded-lg">{success}</div>}

        {/* Organization Information */}
        <Card className="bg-card border-border max-w-2xl">
          <CardHeader>
            <CardTitle>Organization Information</CardTitle>
            <CardDescription>Update your organization details</CardDescription>
          </CardHeader>
          <CardContent className="space-y-4">
            <div className="space-y-2">
              <label className="text-sm font-medium">Organization Name</label>
              <Input
                value={settings.name}
                onChange={(e) => setSettings({ ...settings, name: e.target.value })}
                className="bg-background border-border"
              />
            </div>
            <div className="space-y-2">
              <label className="text-sm font-medium">Email</label>
              <Input
                type="email"
                value={settings.email}
                onChange={(e) => setSettings({ ...settings, email: e.target.value })}
                className="bg-background border-border"
              />
            </div>
            <div className="space-y-2">
              <label className="text-sm font-medium">Phone</label>
              <Input
                value={settings.phone}
                onChange={(e) => setSettings({ ...settings, phone: e.target.value })}
                className="bg-background border-border"
              />
            </div>
            <div className="space-y-2">
              <label className="text-sm font-medium">Address</label>
              <Input
                value={settings.address}
                onChange={(e) => setSettings({ ...settings, address: e.target.value })}
                className="bg-background border-border"
              />
            </div>
            <Button onClick={handleSave} disabled={saving} className="bg-primary hover:bg-primary-hover text-white">
              {saving ? "Saving..." : "Save Changes"}
            </Button>
          </CardContent>
        </Card>

        {/* Admin Profile */}
        <Card className="bg-card border-border max-w-2xl">
          <CardHeader>
            <CardTitle>Admin Profile</CardTitle>
            <CardDescription>Your organization admin information</CardDescription>
          </CardHeader>
          <CardContent className="space-y-4">
            <div className="space-y-2">
              <label className="text-sm font-medium text-muted-foreground">Organization</label>
              <p className="text-sm">{orgName}</p>
            </div>
            <Separator />
            <div className="space-y-2">
              <label className="text-sm font-medium text-muted-foreground">Admin Role</label>
              <p className="text-sm">Administrator</p>
            </div>
          </CardContent>
        </Card>
      </div>
    </DashboardLayout>
  )
}

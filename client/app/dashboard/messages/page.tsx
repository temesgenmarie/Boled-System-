"use client"

import { useEffect, useState } from "react"
import { useRouter } from "next/navigation"
import DashboardLayout from "@/components/dashboard/layout"
import MessagesTable from "@/components/dashboard/messages-table"
import SendMessageDialog from "@/components/dashboard/send-message-dialog"
import { Button } from "@/components/ui/button"
import { Card, CardContent, CardHeader, CardTitle } from "@/components/ui/card"
import { Plus } from "lucide-react"
import { useAuth } from "@/lib/auth-context"

interface Message {
  id: string
  title?: string
  content?: string
  type: string
  sentAt: string
  recipientCount: number
  place?: string
  time?: string
  address?: string
  deathType?: string
}

interface MessageStats {
  period: string
  count: number
}

export default function MessagesPage() {
  const router = useRouter()
  const { isAuthenticated, orgId, loading: authLoading } = useAuth()
  const [messages, setMessages] = useState<Message[]>([])
  const [loading, setLoading] = useState(true)
  const [dialogOpen, setDialogOpen] = useState(false)
  const [error, setError] = useState<string | null>(null)

  const [stats, setStats] = useState({
    oneDay: 0,
    sevenDays: 0,
    month: 0,
    year: 0,
  })

  useEffect(() => {
    if (!authLoading && !isAuthenticated) {
      router.push("/")
      return
    }
    if (orgId) {
      fetchMessages()
      fetchStats()
    }
  }, [isAuthenticated, authLoading, orgId, router])

  const fetchMessages = async () => {
    try {
      setError(null)
      const response = await fetch(`/api/messages?orgId=${orgId}`)
      if (response.ok) {
        const data = await response.json()
        setMessages(data)
      } else {
        setError("Failed to fetch messages")
      }
    } catch (error) {
      console.error("Failed to fetch messages:", error)
      setError("An error occurred while fetching messages")
    } finally {
      setLoading(false)
    }
  }

  const fetchStats = async () => {
    try {
      const periods = ["1day", "7days", "month", "year"]
      const statsData: any = {}

      for (const period of periods) {
        const response = await fetch(`/api/messages?orgId=${orgId}&period=${period}`, {
          method: "PUT",
        })
        if (response.ok) {
          const data = await response.json()
          statsData[period] = data.count
        }
      }

      setStats({
        oneDay: statsData["1day"] || 0,
        sevenDays: statsData["7days"] || 0,
        month: statsData["month"] || 0,
        year: statsData["year"] || 0,
      })
    } catch (error) {
      console.error("Failed to fetch stats:", error)
    }
  }

  const handleSendMessage = async (messageData: any) => {
    try {
      setError(null)
      const response = await fetch("/api/messages", {
        method: "POST",
        headers: { "Content-Type": "application/json" },
        body: JSON.stringify({ ...messageData, orgId }),
      })

      if (response.ok) {
        setDialogOpen(false)
        fetchMessages()
        fetchStats()
      } else {
        setError("Failed to send message")
      }
    } catch (error) {
      console.error("Failed to send message:", error)
      setError("An error occurred while sending the message")
    }
  }

  if (authLoading) {
    return <div className="flex items-center justify-center min-h-screen">Loading...</div>
  }

  return (
    <DashboardLayout>
      <div className="space-y-6">
        <div className="flex items-center justify-between">
          <div>
            <h1 className="text-3xl font-bold">Messages</h1>
            <p className="text-muted-foreground mt-2">Send announcements and funeral notices to members</p>
          </div>
          <Button onClick={() => setDialogOpen(true)} className="bg-primary hover:bg-primary-hover text-white">
            <Plus className="mr-2 h-4 w-4" />
            Send Message
          </Button>
        </div>

        <div className="grid grid-cols-1 md:grid-cols-4 gap-4">
          <Card className="bg-card border-border">
            <CardHeader className="pb-2">
              <CardTitle className="text-sm font-medium text-muted-foreground">Last 24 Hours</CardTitle>
            </CardHeader>
            <CardContent>
              <div className="text-2xl font-bold">{stats.oneDay}</div>
              <p className="text-xs text-muted-foreground mt-1">Messages sent</p>
            </CardContent>
          </Card>

          <Card className="bg-card border-border">
            <CardHeader className="pb-2">
              <CardTitle className="text-sm font-medium text-muted-foreground">Last 7 Days</CardTitle>
            </CardHeader>
            <CardContent>
              <div className="text-2xl font-bold">{stats.sevenDays}</div>
              <p className="text-xs text-muted-foreground mt-1">Messages sent</p>
            </CardContent>
          </Card>

          <Card className="bg-card border-border">
            <CardHeader className="pb-2">
              <CardTitle className="text-sm font-medium text-muted-foreground">Last Month</CardTitle>
            </CardHeader>
            <CardContent>
              <div className="text-2xl font-bold">{stats.month}</div>
              <p className="text-xs text-muted-foreground mt-1">Messages sent</p>
            </CardContent>
          </Card>

          <Card className="bg-card border-border">
            <CardHeader className="pb-2">
              <CardTitle className="text-sm font-medium text-muted-foreground">Last Year</CardTitle>
            </CardHeader>
            <CardContent>
              <div className="text-2xl font-bold">{stats.year}</div>
              <p className="text-xs text-muted-foreground mt-1">Messages sent</p>
            </CardContent>
          </Card>
        </div>

        {error && (
          <div className="bg-destructive/10 border border-destructive text-destructive px-4 py-3 rounded-lg">
            {error}
          </div>
        )}

        <MessagesTable messages={messages} loading={loading} />

        <SendMessageDialog open={dialogOpen} onOpenChange={setDialogOpen} onSubmit={handleSendMessage} />
      </div>
    </DashboardLayout>
  )
}

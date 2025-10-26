"use client"

import { useEffect, useState } from "react"
import { Card, CardContent, CardDescription, CardHeader, CardTitle } from "@/components/ui/card"
import { Users, MessageSquare, Activity } from "lucide-react"

interface DashboardStats {
  totalMembers: number
  totalMessages: number
  activeUsers: number
}

export default function DashboardOverview() {
  const [stats, setStats] = useState<DashboardStats>({
    totalMembers: 0,
    totalMessages: 0,
    activeUsers: 0,
  })

  useEffect(() => {
    const fetchStats = async () => {
      try {
        const orgId = localStorage.getItem("orgId")
        const response = await fetch(`/api/dashboard/stats?orgId=${orgId}`)
        if (response.ok) {
          const data = await response.json()
          setStats(data)
        }
      } catch (error) {
        console.error("Failed to fetch stats:", error)
      }
    }

    fetchStats()
  }, [])

  const statCards = [
    {
      title: "Total Members",
      value: stats.totalMembers,
      icon: Users,
      color: "text-primary",
    },
    {
      title: "Messages Sent",
      value: stats.totalMessages,
      icon: MessageSquare,
      color: "text-accent",
    },
    {
      title: "Active Users",
      value: stats.activeUsers,
      icon: Activity,
      color: "text-muted-foreground",
    },
  ]

  return (
    <div className="space-y-8">
      <div>
        <h1 className="text-3xl font-bold">Dashboard</h1>
        <p className="text-muted-foreground mt-2">Welcome to your organization admin panel</p>
      </div>

      <div className="grid grid-cols-1 md:grid-cols-3 gap-6">
        {statCards.map((card) => (
          <Card key={card.title} className="bg-card border-border">
            <CardHeader className="flex flex-row items-center justify-between space-y-0 pb-2">
              <CardTitle className="text-sm font-medium">{card.title}</CardTitle>
              <card.icon className={`${card.color} h-4 w-4`} />
            </CardHeader>
            <CardContent>
              <div className="text-2xl font-bold">{card.value}</div>
            </CardContent>
          </Card>
        ))}
      </div>

      <Card className="bg-card border-border">
        <CardHeader>
          <CardTitle>Recent Activity</CardTitle>
          <CardDescription>Latest updates from your organization</CardDescription>
        </CardHeader>
        <CardContent>
          <div className="space-y-4">
            <p className="text-muted-foreground text-sm">No recent activity</p>
          </div>
        </CardContent>
      </Card>
    </div>
  )
}

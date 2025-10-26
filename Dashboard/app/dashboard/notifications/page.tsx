"use client"

import { Card, CardContent, CardHeader, CardTitle } from "@/components/ui/card"
import { Badge } from "@/components/ui/badge"
import { Button } from "@/components/ui/button"
import { Bell, MessageSquare, Building2, Users, Trash2 } from "lucide-react"

const notifications = [
  {
    id: 1,
    type: "message",
    title: "New message sent",
    description: "Organization Alpha sent a funeral notification to 150 recipients",
    time: "5 minutes ago",
    read: false,
  },
  {
    id: 2,
    type: "organization",
    title: "Organization created",
    description: 'New organization "Zeta Corp" was added to the system',
    time: "1 hour ago",
    read: false,
  },
  {
    id: 3,
    type: "member",
    title: "New member added",
    description: "John Smith was added to Beta Industries",
    time: "2 hours ago",
    read: true,
  },
  {
    id: 4,
    type: "message",
    title: "Bulk message sent",
    description: "Gamma Solutions sent announcements to 200 recipients",
    time: "3 hours ago",
    read: true,
  },
  {
    id: 5,
    type: "organization",
    title: "Organization updated",
    description: "Delta Enterprises updated their contact information",
    time: "5 hours ago",
    read: true,
  },
]

const activityLog = [
  { action: 'Created organization "Theta Inc"', user: "Superadmin", time: "2024-10-26 10:30 AM" },
  { action: "Deleted message MSG045", user: "Superadmin", time: "2024-10-26 09:15 AM" },
  { action: "Updated member profile M234", user: "Superadmin", time: "2024-10-25 04:20 PM" },
  { action: "Exported analytics data", user: "Superadmin", time: "2024-10-25 02:10 PM" },
]

export default function NotificationsPage() {
  const getIcon = (type: string) => {
    switch (type) {
      case "message":
        return <MessageSquare className="w-5 h-5" />
      case "organization":
        return <Building2 className="w-5 h-5" />
      case "member":
        return <Users className="w-5 h-5" />
      default:
        return <Bell className="w-5 h-5" />
    }
  }

  return (
    <div className="space-y-6">
      <div>
        <h1 className="text-3xl font-bold tracking-tight">Notifications</h1>
        <p className="text-muted-foreground">Stay updated with system activities</p>
      </div>

      <div className="grid gap-6 md:grid-cols-2">
        <Card>
          <CardHeader className="flex flex-row items-center justify-between">
            <CardTitle>Recent Notifications</CardTitle>
            <Button variant="ghost" size="sm">
              Mark all as read
            </Button>
          </CardHeader>
          <CardContent>
            <div className="space-y-4">
              {notifications.map((notification) => (
                <div
                  key={notification.id}
                  className={`flex gap-3 p-3 rounded-lg border ${
                    !notification.read ? "bg-accent/50 border-accent" : "border-border"
                  }`}
                >
                  <div className="mt-1">{getIcon(notification.type)}</div>
                  <div className="flex-1 space-y-1">
                    <div className="flex items-start justify-between gap-2">
                      <p className="font-medium text-sm">{notification.title}</p>
                      {!notification.read && (
                        <Badge variant="default" className="text-xs">
                          New
                        </Badge>
                      )}
                    </div>
                    <p className="text-sm text-muted-foreground">{notification.description}</p>
                    <p className="text-xs text-muted-foreground">{notification.time}</p>
                  </div>
                  <Button variant="ghost" size="icon" className="shrink-0">
                    <Trash2 className="w-4 h-4" />
                  </Button>
                </div>
              ))}
            </div>
          </CardContent>
        </Card>

        <Card>
          <CardHeader>
            <CardTitle>Activity Log</CardTitle>
          </CardHeader>
          <CardContent>
            <div className="space-y-4">
              {activityLog.map((log, index) => (
                <div key={index} className="flex gap-3 pb-4 border-b border-border last:border-0 last:pb-0">
                  <div className="w-2 h-2 rounded-full bg-chart-1 mt-2" />
                  <div className="flex-1">
                    <p className="text-sm font-medium">{log.action}</p>
                    <p className="text-xs text-muted-foreground mt-1">
                      by {log.user} • {log.time}
                    </p>
                  </div>
                </div>
              ))}
            </div>
          </CardContent>
        </Card>
      </div>
    </div>
  )
}

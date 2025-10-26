"use client"

import { Card, CardContent, CardHeader, CardTitle } from "@/components/ui/card"

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

interface MessagesTableProps {
  messages: Message[]
  loading: boolean
}

export default function MessagesTable({ messages, loading }: MessagesTableProps) {
  if (loading) {
    return <div className="text-center py-8">Loading messages...</div>
  }

  const getMessageTitle = (message: Message) => {
    if (message.type === "announcement") {
      return message.title || "Announcement"
    } else if (message.type === "funeral") {
      return `Funeral Notice - ${message.place || "Unknown"}`
    }
    return message.title || "Message"
  }

  const getMessageDetails = (message: Message) => {
    if (message.type === "announcement") {
      return `📍 ${message.place} | 🕐 ${message.time ? new Date(message.time).toLocaleString() : "TBD"}`
    } else if (message.type === "funeral") {
      return `📍 ${message.place} | 📮 ${message.address} | ${message.deathType === "new" ? "🕯️ New" : "🕯️ Anniversary"}`
    }
    return ""
  }

  return (
    <Card className="bg-card border-border">
      <CardHeader>
        <CardTitle>Message History</CardTitle>
      </CardHeader>
      <CardContent>
        <div className="overflow-x-auto">
          <table className="w-full">
            <thead>
              <tr className="border-b border-border">
                <th className="text-left py-3 px-4 font-semibold">Message</th>
                <th className="text-left py-3 px-4 font-semibold">Type</th>
                <th className="text-left py-3 px-4 font-semibold">Details</th>
                <th className="text-left py-3 px-4 font-semibold">Recipients</th>
                <th className="text-left py-3 px-4 font-semibold">Sent At</th>
              </tr>
            </thead>
            <tbody>
              {messages.length === 0 ? (
                <tr>
                  <td colSpan={5} className="text-center py-8 text-muted-foreground">
                    No messages sent yet
                  </td>
                </tr>
              ) : (
                messages.map((message) => (
                  <tr key={message.id} className="border-b border-border hover:bg-background">
                    <td className="py-3 px-4 font-medium">{getMessageTitle(message)}</td>
                    <td className="py-3 px-4">
                      <span
                        className={`px-2 py-1 rounded text-sm font-medium ${
                          message.type === "announcement"
                            ? "bg-blue-500/10 text-blue-600"
                            : "bg-purple-500/10 text-purple-600"
                        }`}
                      >
                        {message.type === "announcement" ? "📢 Announcement" : "🕯️ Funeral"}
                      </span>
                    </td>
                    <td className="py-3 px-4 text-sm text-muted-foreground">{getMessageDetails(message)}</td>
                    <td className="py-3 px-4">{message.recipientCount}</td>
                    <td className="py-3 px-4 text-sm text-muted-foreground">
                      {new Date(message.sentAt).toLocaleDateString()}
                    </td>
                  </tr>
                ))
              )}
            </tbody>
          </table>
        </div>
      </CardContent>
    </Card>
  )
}

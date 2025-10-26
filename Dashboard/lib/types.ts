import type React from "react"
export interface Organization {
  id: string
  name: string
  members: number
  messages: number
  created: string
  status: "active" | "inactive"
  description?: string
  email?: string
  phone?: string
}

export interface Member {
  id: string
  name: string
  email: string
  role: "admin" | "member" | "viewer"
  organization: string
  joinedDate: string
  status: "active" | "inactive"
  lastActive?: string
}

export interface Message {
  id: string
  organizationId: string
  organizationName: string
  sender: string
  content: string
  timestamp: string
  status: "sent" | "delivered" | "read"
  recipients: number
}

export interface Activity {
  id: string
  type: "message" | "org" | "member"
  text: string
  time: string
  timestamp: Date
}

export interface KPI {
  title: string
  value: string
  change: string
  icon: React.ComponentType<{ className?: string }>
}

export interface ApiResponse<T> {
  success: boolean
  data?: T
  error?: string
  message?: string
}

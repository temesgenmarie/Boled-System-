import type { Organization, Member, Message, Activity } from "./types"

export const mockOrganizations: Organization[] = [
  { id: "ORG001", name: "Alpha Corporation", members: 45, messages: 450, created: "2024-01-15", status: "active" },
  { id: "ORG002", name: "Beta Industries", members: 32, messages: 380, created: "2024-02-20", status: "active" },
  { id: "ORG003", name: "Gamma Solutions", members: 28, messages: 320, created: "2024-03-10", status: "inactive" },
  { id: "ORG004", name: "Delta Enterprises", members: 51, messages: 280, created: "2024-04-05", status: "active" },
  { id: "ORG005", name: "Epsilon Group", members: 19, messages: 240, created: "2024-05-12", status: "active" },
]

export const mockMembers: Member[] = [
  {
    id: "MEM001",
    name: "John Smith",
    email: "john@alpha.com",
    role: "admin",
    organization: "Alpha Corporation",
    joinedDate: "2024-01-15",
    status: "active",
    lastActive: "2 minutes ago",
  },
  {
    id: "MEM002",
    name: "Sarah Johnson",
    email: "sarah@beta.com",
    role: "member",
    organization: "Beta Industries",
    joinedDate: "2024-02-20",
    status: "active",
    lastActive: "1 hour ago",
  },
  {
    id: "MEM003",
    name: "Mike Davis",
    email: "mike@gamma.com",
    role: "viewer",
    organization: "Gamma Solutions",
    joinedDate: "2024-03-10",
    status: "inactive",
    lastActive: "3 days ago",
  },
  {
    id: "MEM004",
    name: "Emily Wilson",
    email: "emily@delta.com",
    role: "admin",
    organization: "Delta Enterprises",
    joinedDate: "2024-04-05",
    status: "active",
    lastActive: "30 minutes ago",
  },
  {
    id: "MEM005",
    name: "Robert Brown",
    email: "robert@epsilon.com",
    role: "member",
    organization: "Epsilon Group",
    joinedDate: "2024-05-12",
    status: "active",
    lastActive: "5 minutes ago",
  },
]

export const mockMessages: Message[] = [
  {
    id: "MSG001",
    organizationId: "ORG001",
    organizationName: "Alpha Corporation",
    sender: "John Smith",
    content: "Q3 performance metrics update",
    timestamp: "2024-12-20 14:30",
    status: "read",
    recipients: 45,
  },
  {
    id: "MSG002",
    organizationId: "ORG002",
    organizationName: "Beta Industries",
    sender: "Sarah Johnson",
    content: "Team meeting scheduled for tomorrow",
    timestamp: "2024-12-20 13:15",
    status: "delivered",
    recipients: 32,
  },
  {
    id: "MSG003",
    organizationId: "ORG003",
    organizationName: "Gamma Solutions",
    sender: "Mike Davis",
    content: "Project deadline extension approved",
    timestamp: "2024-12-20 11:45",
    status: "sent",
    recipients: 28,
  },
  {
    id: "MSG004",
    organizationId: "ORG004",
    organizationName: "Delta Enterprises",
    sender: "Emily Wilson",
    content: "New client onboarding process",
    timestamp: "2024-12-20 10:20",
    status: "read",
    recipients: 51,
  },
  {
    id: "MSG005",
    organizationId: "ORG005",
    organizationName: "Epsilon Group",
    sender: "Robert Brown",
    content: "Budget allocation for next quarter",
    timestamp: "2024-12-20 09:00",
    status: "delivered",
    recipients: 19,
  },
]

export const mockActivities: Activity[] = [
  {
    id: "ACT001",
    type: "message",
    text: "New message sent by Organization Alpha",
    time: "2 minutes ago",
    timestamp: new Date(Date.now() - 2 * 60000),
  },
  {
    id: "ACT002",
    type: "org",
    text: "Organization Beta was created",
    time: "15 minutes ago",
    timestamp: new Date(Date.now() - 15 * 60000),
  },
  {
    id: "ACT003",
    type: "message",
    text: "Bulk message sent to 150 recipients",
    time: "1 hour ago",
    timestamp: new Date(Date.now() - 60 * 60000),
  },
  {
    id: "ACT004",
    type: "org",
    text: "Organization Gamma updated",
    time: "2 hours ago",
    timestamp: new Date(Date.now() - 2 * 60 * 60000),
  },
  {
    id: "ACT005",
    type: "message",
    text: "New announcement from Organization Delta",
    time: "3 hours ago",
    timestamp: new Date(Date.now() - 3 * 60 * 60000),
  },
]

export const mockKPIData = [
  { title: "Total Organizations", value: "248", change: "+12%", icon: "Building2" },
  { title: "Total Members", value: "3,842", change: "+18%", icon: "Users" },
  { title: "Messages Today", value: "156", change: "+8%", icon: "MessageSquare" },
  { title: "Messages This Month", value: "4,231", change: "+23%", icon: "TrendingUp" },
]

export const mockMessagesPerOrg = [
  { name: "Org A", messages: 450 },
  { name: "Org B", messages: 380 },
  { name: "Org C", messages: 320 },
  { name: "Org D", messages: 280 },
  { name: "Org E", messages: 240 },
]

export const mockMessageVolume = [
  { day: "Mon", messages: 120 },
  { day: "Tue", messages: 150 },
  { day: "Wed", messages: 180 },
  { day: "Thu", messages: 140 },
  { day: "Fri", messages: 200 },
  { day: "Sat", messages: 90 },
  { day: "Sun", messages: 85 },
]

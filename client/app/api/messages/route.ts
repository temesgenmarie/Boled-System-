import { type NextRequest, NextResponse } from "next/server"

const messages: any[] = [
  {
    id: "msg-1",
    title: "Welcome to our organization",
    content: "We are excited to have you here",
    type: "announcement",
    place: "Main Hall",
    time: "2024-03-01T10:00:00",
    sentAt: new Date("2024-03-01"),
    recipientCount: 2,
    orgId: "org-1",
  },
]

export async function GET(request: NextRequest) {
  const { searchParams } = new URL(request.url)
  const orgId = searchParams.get("orgId")

  const orgMessages = messages.filter((m) => m.orgId === orgId)
  return NextResponse.json(orgMessages)
}

export async function POST(request: NextRequest) {
  try {
    const body = await request.json()
    const { type, orgId, ...messageData } = body

    const newMessage = {
      id: `msg-${Date.now()}`,
      type,
      sentAt: new Date(),
      recipientCount: 2,
      orgId,
      ...messageData,
    }

    messages.push(newMessage)
    return NextResponse.json(newMessage)
  } catch (error) {
    return NextResponse.json({ error: "Failed to send message" }, { status: 500 })
  }
}

export async function PUT(request: NextRequest) {
  const { searchParams } = new URL(request.url)
  const orgId = searchParams.get("orgId")
  const period = searchParams.get("period") // "1day", "7days", "month", "year"

  const orgMessages = messages.filter((m) => m.orgId === orgId)

  const now = new Date()
  const startDate = new Date()

  if (period === "1day") {
    startDate.setDate(now.getDate() - 1)
  } else if (period === "7days") {
    startDate.setDate(now.getDate() - 7)
  } else if (period === "month") {
    startDate.setMonth(now.getMonth() - 1)
  } else if (period === "year") {
    startDate.setFullYear(now.getFullYear() - 1)
  }

  const filteredMessages = orgMessages.filter((m) => new Date(m.sentAt) >= startDate)

  return NextResponse.json({
    period,
    count: filteredMessages.length,
    messages: filteredMessages,
  })
}

import { type NextRequest, NextResponse } from "next/server"

// Mock database
const members: any[] = [
  {
    id: "member-1",
    name: "John Doe",
    phone: "+1 (555) 123-4567",
    role: "user",
    status: "active",
    joinedAt: new Date("2024-01-15"),
    orgId: "org-1",
  },
  {
    id: "member-2",
    name: "Jane Smith",
    phone: "+1 (555) 234-5678",
    role: "admin",
    status: "active",
    joinedAt: new Date("2024-02-20"),
    orgId: "org-1",
  },
]

export async function GET(request: NextRequest) {
  const { searchParams } = new URL(request.url)
  const orgId = searchParams.get("orgId")

  const orgMembers = members.filter((m) => m.orgId === orgId)
  return NextResponse.json(orgMembers)
}

export async function POST(request: NextRequest) {
  try {
    const { name, phone, orgId } = await request.json()

    const newMember = {
      id: `member-${Date.now()}`,
      name,
      phone,
      role: "user",
      status: "active",
      joinedAt: new Date(),
      orgId,
    }

    members.push(newMember)
    return NextResponse.json(newMember)
  } catch (error) {
    return NextResponse.json({ error: "Failed to add member" }, { status: 500 })
  }
}

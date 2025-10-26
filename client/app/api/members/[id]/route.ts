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

export async function DELETE(request: NextRequest, { params }: { params: { id: string } }) {
  try {
    const memberId = params.id
    const index = members.findIndex((m) => m.id === memberId)

    if (index === -1) {
      return NextResponse.json({ error: "Member not found" }, { status: 404 })
    }

    members.splice(index, 1)
    return NextResponse.json({ success: true })
  } catch (error) {
    return NextResponse.json({ error: "Failed to delete member" }, { status: 500 })
  }
}

export async function PUT(request: NextRequest, { params }: { params: { id: string } }) {
  try {
    const memberId = params.id
    const { role, status } = await request.json()

    const member = members.find((m) => m.id === memberId)

    if (!member) {
      return NextResponse.json({ error: "Member not found" }, { status: 404 })
    }

    if (role) member.role = role
    if (status) member.status = status

    return NextResponse.json(member)
  } catch (error) {
    return NextResponse.json({ error: "Failed to update member" }, { status: 500 })
  }
}

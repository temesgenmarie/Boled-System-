import { type NextRequest, NextResponse } from "next/server"
import { mockMembers } from "@/lib/mock-data"

export async function GET(request: NextRequest, { params }: { params: { id: string } }) {
  try {
    // TODO: Replace with real database query
    // const member = await db.members.findById(params.id)
    const member = mockMembers.find((m) => m.id === params.id)

    if (!member) {
      return NextResponse.json({ success: false, error: "Member not found" }, { status: 404 })
    }

    return NextResponse.json({
      success: true,
      data: member,
    })
  } catch (error) {
    return NextResponse.json(
      {
        success: false,
        error: error instanceof Error ? error.message : "Failed to fetch member",
      },
      { status: 500 },
    )
  }
}

export async function PUT(request: NextRequest, { params }: { params: { id: string } }) {
  try {
    const body = await request.json()
    // TODO: Replace with real database update
    // const member = await db.members.update(params.id, body)
    const index = mockMembers.findIndex((m) => m.id === params.id)
    if (index === -1) {
      return NextResponse.json({ success: false, error: "Member not found" }, { status: 404 })
    }

    mockMembers[index] = { ...mockMembers[index], ...body }

    return NextResponse.json({
      success: true,
      data: mockMembers[index],
      message: "Member updated successfully",
    })
  } catch (error) {
    return NextResponse.json(
      {
        success: false,
        error: error instanceof Error ? error.message : "Failed to update member",
      },
      { status: 500 },
    )
  }
}

export async function DELETE(request: NextRequest, { params }: { params: { id: string } }) {
  try {
    // TODO: Replace with real database delete
    // await db.members.delete(params.id)
    const index = mockMembers.findIndex((m) => m.id === params.id)
    if (index === -1) {
      return NextResponse.json({ success: false, error: "Member not found" }, { status: 404 })
    }

    mockMembers.splice(index, 1)

    return NextResponse.json({
      success: true,
      message: "Member deleted successfully",
    })
  } catch (error) {
    return NextResponse.json(
      {
        success: false,
        error: error instanceof Error ? error.message : "Failed to delete member",
      },
      { status: 500 },
    )
  }
}

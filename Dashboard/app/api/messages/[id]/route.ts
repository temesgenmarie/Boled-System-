import { type NextRequest, NextResponse } from "next/server"
import { mockMessages } from "@/lib/mock-data"

export async function DELETE(request: NextRequest, { params }: { params: { id: string } }) {
  try {
    const index = mockMessages.findIndex((m) => m.id === params.id)
    if (index === -1) {
      return NextResponse.json({ success: false, error: "Message not found" }, { status: 404 })
    }

    mockMessages.splice(index, 1)

    return NextResponse.json({
      success: true,
      message: "Message deleted successfully",
    })
  } catch (error) {
    return NextResponse.json(
      {
        success: false,
        error: error instanceof Error ? error.message : "Failed to delete message",
      },
      { status: 500 },
    )
  }
}

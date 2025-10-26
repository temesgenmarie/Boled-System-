import { type NextRequest, NextResponse } from "next/server"
import { mockMessages } from "@/lib/mock-data"

export async function GET(request: NextRequest) {
  try {
    // TODO: Replace with real database query
    // const messages = await db.messages.findAll()
    return NextResponse.json({
      success: true,
      data: mockMessages,
    })
  } catch (error) {
    return NextResponse.json(
      {
        success: false,
        error: error instanceof Error ? error.message : "Failed to fetch messages",
      },
      { status: 500 },
    )
  }
}

import { type NextRequest, NextResponse } from "next/server"
import { mockMessagesPerOrg } from "@/lib/mock-data"

export async function GET(request: NextRequest) {
  try {
    // TODO: Replace with real database query
    // const data = await db.analytics.getMessagesPerOrg()
    return NextResponse.json({
      success: true,
      data: mockMessagesPerOrg,
    })
  } catch (error) {
    return NextResponse.json(
      {
        success: false,
        error: error instanceof Error ? error.message : "Failed to fetch messages per organization",
      },
      { status: 500 },
    )
  }
}

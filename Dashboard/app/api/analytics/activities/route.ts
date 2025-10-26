import { type NextRequest, NextResponse } from "next/server"
import { mockActivities } from "@/lib/mock-data"

export async function GET(request: NextRequest) {
  try {
    // TODO: Replace with real database query
    // const activities = await db.activities.findAll()
    return NextResponse.json({
      success: true,
      data: mockActivities,
    })
  } catch (error) {
    return NextResponse.json(
      {
        success: false,
        error: error instanceof Error ? error.message : "Failed to fetch activities",
      },
      { status: 500 },
    )
  }
}

import { type NextRequest, NextResponse } from "next/server"
import { mockKPIData } from "@/lib/mock-data"

export async function GET(request: NextRequest) {
  try {
    // TODO: Replace with real database query
    // const kpis = await db.analytics.getKPIs()
    return NextResponse.json({
      success: true,
      data: mockKPIData,
    })
  } catch (error) {
    return NextResponse.json(
      {
        success: false,
        error: error instanceof Error ? error.message : "Failed to fetch KPIs",
      },
      { status: 500 },
    )
  }
}

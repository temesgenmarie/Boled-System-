import { type NextRequest, NextResponse } from "next/server"

export async function GET(request: NextRequest) {
  const { searchParams } = new URL(request.url)
  const orgId = searchParams.get("orgId")

  // Mock stats - replace with real database queries
  return NextResponse.json({
    totalMembers: 2,
    totalMessages: 1,
    activeUsers: 1,
  })
}

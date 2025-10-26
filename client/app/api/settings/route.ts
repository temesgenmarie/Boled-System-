import { type NextRequest, NextResponse } from "next/server"

// Mock database
const settings: Record<string, any> = {
  "org-1": {
    name: "Acme Organization",
    email: "admin@acme.com",
    phone: "+1-555-0123",
    address: "123 Main St, City, State",
  },
}

export async function GET(request: NextRequest) {
  const { searchParams } = new URL(request.url)
  const orgId = searchParams.get("orgId")

  return NextResponse.json(settings[orgId!] || {})
}

export async function PUT(request: NextRequest) {
  try {
    const { name, email, phone, address, orgId } = await request.json()

    settings[orgId] = { name, email, phone, address }
    return NextResponse.json({ success: true })
  } catch (error) {
    return NextResponse.json({ error: "Failed to update settings" }, { status: 500 })
  }
}

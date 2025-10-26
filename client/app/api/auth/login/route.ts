import { type NextRequest, NextResponse } from "next/server"

// Mock database - replace with real database
const organizations = [
  {
    id: "org-1",
    name: "Acme Organization",
    email: "admin@acme.com",
    password: "password123",
  },
  {
    id: "org-2",
    name: "Tech Corp",
    email: "admin@techcorp.com",
    password: "password123",
  },
]

export async function POST(request: NextRequest) {
  try {
    const { email, password } = await request.json()

    const org = organizations.find((o) => o.email === email && o.password === password)

    if (!org) {
      return NextResponse.json({ error: "Invalid credentials" }, { status: 401 })
    }

    // Generate a simple token (replace with JWT in production)
    const token = Buffer.from(`${org.id}:${Date.now()}`).toString("base64")

    return NextResponse.json({
      token,
      orgId: org.id,
      orgName: org.name,
    })
  } catch (error) {
    return NextResponse.json({ error: "Internal server error" }, { status: 500 })
  }
}

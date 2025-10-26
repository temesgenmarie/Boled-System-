import { type NextRequest, NextResponse } from "next/server"
import { mockOrganizations } from "@/lib/mock-data"

export async function GET(request: NextRequest, { params }: { params: { id: string } }) {
  try {
    // TODO: Replace with real database query
    // const organization = await db.organizations.findById(params.id)
    const organization = mockOrganizations.find((org) => org.id === params.id)

    if (!organization) {
      return NextResponse.json({ success: false, error: "Organization not found" }, { status: 404 })
    }

    return NextResponse.json({
      success: true,
      data: organization,
    })
  } catch (error) {
    return NextResponse.json(
      {
        success: false,
        error: error instanceof Error ? error.message : "Failed to fetch organization",
      },
      { status: 500 },
    )
  }
}

export async function PUT(request: NextRequest, { params }: { params: { id: string } }) {
  try {
    const body = await request.json()
    // TODO: Replace with real database update
    // const organization = await db.organizations.update(params.id, body)
    const index = mockOrganizations.findIndex((org) => org.id === params.id)
    if (index === -1) {
      return NextResponse.json({ success: false, error: "Organization not found" }, { status: 404 })
    }

    mockOrganizations[index] = { ...mockOrganizations[index], ...body }

    return NextResponse.json({
      success: true,
      data: mockOrganizations[index],
      message: "Organization updated successfully",
    })
  } catch (error) {
    return NextResponse.json(
      {
        success: false,
        error: error instanceof Error ? error.message : "Failed to update organization",
      },
      { status: 500 },
    )
  }
}

export async function DELETE(request: NextRequest, { params }: { params: { id: string } }) {
  try {
    // TODO: Replace with real database delete
    // await db.organizations.delete(params.id)
    const index = mockOrganizations.findIndex((org) => org.id === params.id)
    if (index === -1) {
      return NextResponse.json({ success: false, error: "Organization not found" }, { status: 404 })
    }

    mockOrganizations.splice(index, 1)

    return NextResponse.json({
      success: true,
      message: "Organization deleted successfully",
    })
  } catch (error) {
    return NextResponse.json(
      {
        success: false,
        error: error instanceof Error ? error.message : "Failed to delete organization",
      },
      { status: 500 },
    )
  }
}

"use client"

import { useEffect, useState } from "react"
import { useRouter } from "next/navigation"
import DashboardLayout from "@/components/dashboard/layout"
import MembersTable from "@/components/dashboard/members-table"
import AddMemberDialog from "@/components/dashboard/add-member-dialog"
import { Button } from "@/components/ui/button"
import { Plus } from "lucide-react"
import { useAuth } from "@/lib/auth-context"

interface Member {
  id: string
  name: string
  phone: string
  role: string
  status: "active" | "inactive"
  joinedAt: string
  orgId: string
}

export default function MembersPage() {
  const router = useRouter()
  const { isAuthenticated, orgId, loading: authLoading } = useAuth()
  const [members, setMembers] = useState<Member[]>([])
  const [loading, setLoading] = useState(true)
  const [dialogOpen, setDialogOpen] = useState(false)
  const [error, setError] = useState<string | null>(null)

  useEffect(() => {
    if (!authLoading && !isAuthenticated) {
      router.push("/")
      return
    }
    if (orgId) {
      fetchMembers()
    }
  }, [isAuthenticated, authLoading, orgId, router])

  const fetchMembers = async () => {
    try {
      setError(null)
      const response = await fetch(`/api/members?orgId=${orgId}`)
      if (response.ok) {
        const data = await response.json()
        setMembers(data)
      } else {
        setError("Failed to fetch members")
      }
    } catch (error) {
      console.error("Failed to fetch members:", error)
      setError("An error occurred while fetching members")
    } finally {
      setLoading(false)
    }
  }

  const handleAddMember = async (memberData: { name: string; phone: string }) => {
    try {
      setError(null)
      const response = await fetch("/api/members", {
        method: "POST",
        headers: { "Content-Type": "application/json" },
        body: JSON.stringify({ ...memberData, orgId }),
      })

      if (response.ok) {
        setDialogOpen(false)
        fetchMembers()
      } else {
        setError("Failed to add member")
      }
    } catch (error) {
      console.error("Failed to add member:", error)
      setError("An error occurred while adding the member")
    }
  }

  const handleDeleteMember = async (memberId: string) => {
    if (!confirm("Are you sure you want to delete this member?")) {
      return
    }
    try {
      setError(null)
      const response = await fetch(`/api/members/${memberId}`, { method: "DELETE" })
      if (response.ok) {
        fetchMembers()
      } else {
        setError("Failed to delete member")
      }
    } catch (error) {
      console.error("Failed to delete member:", error)
      setError("An error occurred while deleting the member")
    }
  }

  const handleEditMember = async (memberId: string, data: { role: string }) => {
    try {
      setError(null)
      const response = await fetch(`/api/members/${memberId}`, {
        method: "PUT",
        headers: { "Content-Type": "application/json" },
        body: JSON.stringify(data),
      })

      if (response.ok) {
        fetchMembers()
      } else {
        setError("Failed to update member")
      }
    } catch (error) {
      console.error("Failed to update member:", error)
      setError("An error occurred while updating the member")
    }
  }

  const handleToggleStatus = async (memberId: string, status: "active" | "inactive") => {
    try {
      setError(null)
      const response = await fetch(`/api/members/${memberId}`, {
        method: "PUT",
        headers: { "Content-Type": "application/json" },
        body: JSON.stringify({ status }),
      })

      if (response.ok) {
        fetchMembers()
      } else {
        setError("Failed to update member status")
      }
    } catch (error) {
      console.error("Failed to update member status:", error)
      setError("An error occurred while updating the member status")
    }
  }

  if (authLoading) {
    return <div className="flex items-center justify-center min-h-screen">Loading...</div>
  }

  return (
    <DashboardLayout>
      <div className="space-y-6">
        <div className="flex items-center justify-between">
          <div>
            <h1 className="text-3xl font-bold">Members</h1>
            <p className="text-muted-foreground mt-2">Manage your organization members</p>
          </div>
          <Button onClick={() => setDialogOpen(true)} className="bg-primary hover:bg-primary-hover text-white">
            <Plus className="mr-2 h-4 w-4" />
            Add Member
          </Button>
        </div>

        {error && (
          <div className="bg-destructive/10 border border-destructive text-destructive px-4 py-3 rounded-lg">
            {error}
          </div>
        )}

        <MembersTable
          members={members}
          loading={loading}
          onDelete={handleDeleteMember}
          onEdit={handleEditMember}
          onToggleStatus={handleToggleStatus}
        />

        <AddMemberDialog open={dialogOpen} onOpenChange={setDialogOpen} onSubmit={handleAddMember} />
      </div>
    </DashboardLayout>
  )
}

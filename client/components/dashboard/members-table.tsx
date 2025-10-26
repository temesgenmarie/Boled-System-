"use client"

import { Card, CardContent, CardHeader, CardTitle } from "@/components/ui/card"
import { Button } from "@/components/ui/button"
import { Trash2, Edit2, Power } from "lucide-react"
import { useState } from "react"
import EditMemberDialog from "./edit-member-dialog"

interface Member {
  id: string
  name: string
  phone: string
  role: string
  status: "active" | "inactive"
  joinedAt: string
}

interface MembersTableProps {
  members: Member[]
  loading: boolean
  onDelete: (id: string) => void
  onEdit: (id: string, data: { role: string }) => void
  onToggleStatus: (id: string, status: "active" | "inactive") => void
}

export default function MembersTable({ members, loading, onDelete, onEdit, onToggleStatus }: MembersTableProps) {
  const [editingMember, setEditingMember] = useState<Member | null>(null)
  const [editDialogOpen, setEditDialogOpen] = useState(false)

  if (loading) {
    return <div className="text-center py-8">Loading members...</div>
  }

  const handleEditClick = (member: Member) => {
    setEditingMember(member)
    setEditDialogOpen(true)
  }

  const handleEditSubmit = (role: string) => {
    if (editingMember) {
      onEdit(editingMember.id, { role })
      setEditDialogOpen(false)
      setEditingMember(null)
    }
  }

  return (
    <>
      <Card className="bg-card border-border">
        <CardHeader>
          <CardTitle>Organization Members</CardTitle>
        </CardHeader>
        <CardContent>
          <div className="overflow-x-auto">
            <table className="w-full">
              <thead>
                <tr className="border-b border-border">
                  <th className="text-left py-3 px-4 font-semibold">Name</th>
                  <th className="text-left py-3 px-4 font-semibold">Phone</th>
                  <th className="text-left py-3 px-4 font-semibold">Role</th>
                  <th className="text-left py-3 px-4 font-semibold">Status</th>
                  <th className="text-left py-3 px-4 font-semibold">Joined</th>
                  <th className="text-left py-3 px-4 font-semibold">Actions</th>
                </tr>
              </thead>
              <tbody>
                {members.length === 0 ? (
                  <tr>
                    <td colSpan={6} className="text-center py-8 text-muted-foreground">
                      No members found
                    </td>
                  </tr>
                ) : (
                  members.map((member) => (
                    <tr key={member.id} className="border-b border-border hover:bg-background">
                      <td className="py-3 px-4 font-medium">{member.name}</td>
                      <td className="py-3 px-4 text-sm">{member.phone}</td>
                      <td className="py-3 px-4">
                        <span
                          className={`px-2 py-1 rounded text-sm font-medium ${
                            member.role === "admin" ? "bg-blue-500/20 text-blue-600" : "bg-primary/10 text-primary"
                          }`}
                        >
                          {member.role === "admin" ? "Admin" : "User"}
                        </span>
                      </td>
                      <td className="py-3 px-4">
                        <span
                          className={`px-2 py-1 rounded text-sm font-medium ${
                            member.status === "active"
                              ? "bg-green-500/20 text-green-600"
                              : "bg-gray-500/20 text-gray-600"
                          }`}
                        >
                          {member.status === "active" ? "Active" : "Inactive"}
                        </span>
                      </td>
                      <td className="py-3 px-4 text-sm text-muted-foreground">
                        {new Date(member.joinedAt).toLocaleDateString()}
                      </td>
                      <td className="py-3 px-4">
                        <div className="flex gap-2">
                          <Button
                            variant="ghost"
                            size="sm"
                            onClick={() => handleEditClick(member)}
                            className="text-blue-600 hover:bg-blue-500/10"
                            title="Edit member role"
                          >
                            <Edit2 className="h-4 w-4" />
                          </Button>
                          <Button
                            variant="ghost"
                            size="sm"
                            onClick={() =>
                              onToggleStatus(member.id, member.status === "active" ? "inactive" : "active")
                            }
                            className={
                              member.status === "active"
                                ? "text-orange-600 hover:bg-orange-500/10"
                                : "text-green-600 hover:bg-green-500/10"
                            }
                            title={member.status === "active" ? "Deactivate member" : "Activate member"}
                          >
                            <Power className="h-4 w-4" />
                          </Button>
                          <Button
                            variant="ghost"
                            size="sm"
                            onClick={() => onDelete(member.id)}
                            className="text-destructive hover:bg-destructive/10"
                            title="Delete member"
                          >
                            <Trash2 className="h-4 w-4" />
                          </Button>
                        </div>
                      </td>
                    </tr>
                  ))
                )}
              </tbody>
            </table>
          </div>
        </CardContent>
      </Card>

      {editingMember && (
        <EditMemberDialog
          open={editDialogOpen}
          onOpenChange={setEditDialogOpen}
          member={editingMember}
          onSubmit={handleEditSubmit}
        />
      )}
    </>
  )
}

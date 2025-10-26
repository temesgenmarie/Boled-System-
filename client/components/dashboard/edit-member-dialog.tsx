"use client"

import type React from "react"

import { useState, useEffect } from "react"
import { Dialog, DialogContent, DialogDescription, DialogHeader, DialogTitle } from "@/components/ui/dialog"
import { Button } from "@/components/ui/button"
import { Select, SelectContent, SelectItem, SelectTrigger, SelectValue } from "@/components/ui/select"

interface Member {
  id: string
  name: string
  phone: string
  role: string
  status: "active" | "inactive"
  joinedAt: string
}

interface EditMemberDialogProps {
  open: boolean
  onOpenChange: (open: boolean) => void
  member: Member
  onSubmit: (role: string) => void
}

export default function EditMemberDialog({ open, onOpenChange, member, onSubmit }: EditMemberDialogProps) {
  const [role, setRole] = useState(member.role)

  useEffect(() => {
    setRole(member.role)
  }, [member])

  const handleSubmit = (e: React.FormEvent) => {
    e.preventDefault()
    onSubmit(role)
  }

  return (
    <Dialog open={open} onOpenChange={onOpenChange}>
      <DialogContent className="bg-card border-border">
        <DialogHeader>
          <DialogTitle>Edit Member</DialogTitle>
          <DialogDescription>Update member role and permissions</DialogDescription>
        </DialogHeader>
        <form onSubmit={handleSubmit} className="space-y-4">
          <div className="space-y-2">
            <label className="text-sm font-medium">Name</label>
            <div className="px-3 py-2 bg-background border border-border rounded text-sm">{member.name}</div>
          </div>
          <div className="space-y-2">
            <label className="text-sm font-medium">Phone</label>
            <div className="px-3 py-2 bg-background border border-border rounded text-sm">{member.phone}</div>
          </div>
          <div className="space-y-2">
            <label className="text-sm font-medium">Role</label>
            <Select value={role} onValueChange={setRole}>
              <SelectTrigger className="bg-background border-border">
                <SelectValue />
              </SelectTrigger>
              <SelectContent className="bg-card border-border">
                <SelectItem value="user">User</SelectItem>
                <SelectItem value="admin">Admin</SelectItem>
              </SelectContent>
            </Select>
          </div>
          <div className="flex gap-3 justify-end">
            <Button type="button" variant="outline" onClick={() => onOpenChange(false)}>
              Cancel
            </Button>
            <Button type="submit" className="bg-primary hover:bg-primary-hover text-white">
              Save Changes
            </Button>
          </div>
        </form>
      </DialogContent>
    </Dialog>
  )
}

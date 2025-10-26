"use client"

import { useState, useEffect } from "react"
import { Button } from "@/components/ui/button"
import { Input } from "@/components/ui/input"
import { Card, CardContent, CardHeader } from "@/components/ui/card"
import { Badge } from "@/components/ui/badge"
import { Plus, Search, Eye, Pencil, Trash2, Power, PowerOff } from "lucide-react"
import Link from "next/link"
import { Table, TableBody, TableCell, TableHead, TableHeader, TableRow } from "@/components/ui/table"
import { Select, SelectContent, SelectItem, SelectTrigger, SelectValue } from "@/components/ui/select"
import { organizationsApi } from "@/lib/api-client"
import type { Organization } from "@/lib/types"

export default function OrganizationsPage() {
  const [organizations, setOrganizations] = useState<Organization[]>([])
  const [searchTerm, setSearchTerm] = useState("")
  const [statusFilter, setStatusFilter] = useState("all")
  const [loading, setLoading] = useState(true)

  useEffect(() => {
    const loadOrganizations = async () => {
      try {
        const data = await organizationsApi.getAll()
        setOrganizations(data)
      } catch (error) {
        console.error("Failed to load organizations:", error)
      } finally {
        setLoading(false)
      }
    }

    loadOrganizations()
  }, [])

  const handleDelete = async (id: string) => {
    if (confirm("Are you sure you want to delete this organization?")) {
      try {
        await organizationsApi.delete(id)
        setOrganizations(organizations.filter((org) => org.id !== id))
      } catch (error) {
        console.error("Failed to delete organization:", error)
      }
    }
  }

  const handleToggleStatus = async (org: Organization) => {
    const newStatus = org.status === "active" ? "inactive" : "active"
    const action = newStatus === "active" ? "activate" : "deactivate"

    try {
      const updated = await organizationsApi.update(org.id, { status: newStatus })
      if (updated) {
        setOrganizations(organizations.map((o) => (o.id === org.id ? updated : o)))
      }
    } catch (error) {
      console.error(`Failed to ${action} organization:`, error)
    }
  }

  const filteredOrgs = organizations.filter((org) => {
    const matchesSearch =
      org.name.toLowerCase().includes(searchTerm.toLowerCase()) ||
      org.id.toLowerCase().includes(searchTerm.toLowerCase())
    const matchesStatus = statusFilter === "all" || org.status === statusFilter
    return matchesSearch && matchesStatus
  })

  if (loading) {
    return <div className="text-center py-8">Loading organizations...</div>
  }

  return (
    <div className="space-y-6">
      <div className="flex items-center justify-between">
        <div>
          <h1 className="text-3xl font-bold tracking-tight">Organizations</h1>
          <p className="text-muted-foreground">Manage all organizations in the system</p>
        </div>
        <Link href="/dashboard/organizations/new">
          <Button>
            <Plus className="w-4 h-4 mr-2" />
            Add Organization
          </Button>
        </Link>
      </div>

      <Card>
        <CardHeader>
          <div className="flex flex-col sm:flex-row gap-4">
            <div className="relative flex-1">
              <Search className="absolute left-3 top-1/2 transform -translate-y-1/2 w-4 h-4 text-muted-foreground" />
              <Input
                placeholder="Search by name or ID..."
                value={searchTerm}
                onChange={(e) => setSearchTerm(e.target.value)}
                className="pl-9"
              />
            </div>
            <Select value={statusFilter} onValueChange={setStatusFilter}>
              <SelectTrigger className="w-full sm:w-[180px]">
                <SelectValue placeholder="Filter by status" />
              </SelectTrigger>
              <SelectContent>
                <SelectItem value="all">All Status</SelectItem>
                <SelectItem value="active">Active</SelectItem>
                <SelectItem value="inactive">Inactive</SelectItem>
              </SelectContent>
            </Select>
          </div>
        </CardHeader>
        <CardContent>
          <Table>
            <TableHeader>
              <TableRow>
                <TableHead>Name</TableHead>
                <TableHead>Organization ID</TableHead>
                <TableHead>Members</TableHead>
                <TableHead>Messages</TableHead>
                <TableHead>Created</TableHead>
                <TableHead>Status</TableHead>
                <TableHead className="text-right">Actions</TableHead>
              </TableRow>
            </TableHeader>
            <TableBody>
              {filteredOrgs.map((org) => (
                <TableRow key={org.id}>
                  <TableCell className="font-medium">
                    <Link
                      href={`/dashboard/organizations/${org.id}`}
                      className="hover:underline text-blue-600 dark:text-blue-400"
                    >
                      {org.name}
                    </Link>
                  </TableCell>
                  <TableCell className="font-mono text-sm">{org.id}</TableCell>
                  <TableCell>{org.members}</TableCell>
                  <TableCell>{org.messages}</TableCell>
                  <TableCell>{org.created}</TableCell>
                  <TableCell>
                    <Badge variant={org.status === "active" ? "default" : "secondary"}>{org.status}</Badge>
                  </TableCell>
                  <TableCell className="text-right">
                    <div className="flex justify-end gap-2">
                      <Link href={`/dashboard/organizations/${org.id}`}>
                        <Button variant="ghost" size="icon">
                          <Eye className="w-4 h-4" />
                        </Button>
                      </Link>
                      <Link href={`/dashboard/organizations/${org.id}/edit`}>
                        <Button variant="ghost" size="icon">
                          <Pencil className="w-4 h-4" />
                        </Button>
                      </Link>
                      <Button
                        variant="ghost"
                        size="icon"
                        onClick={() => handleToggleStatus(org)}
                        title={org.status === "active" ? "Deactivate" : "Activate"}
                      >
                        {org.status === "active" ? (
                          <Power className="w-4 h-4 text-green-600" />
                        ) : (
                          <PowerOff className="w-4 h-4 text-gray-400" />
                        )}
                      </Button>
                      <Button variant="ghost" size="icon" onClick={() => handleDelete(org.id)}>
                        <Trash2 className="w-4 h-4 text-destructive" />
                      </Button>
                    </div>
                  </TableCell>
                </TableRow>
              ))}
            </TableBody>
          </Table>
        </CardContent>
      </Card>
    </div>
  )
}

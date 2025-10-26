"use client"

import { useState } from "react"
import { Button } from "@/components/ui/button"
import { Input } from "@/components/ui/input"
import { Card, CardContent, CardHeader } from "@/components/ui/card"
import { Badge } from "@/components/ui/badge"
import { Search, Eye, Trash2 } from "lucide-react"
import { Table, TableBody, TableCell, TableHead, TableHeader, TableRow } from "@/components/ui/table"
import { Select, SelectContent, SelectItem, SelectTrigger, SelectValue } from "@/components/ui/select"

const mockMessages = [
  {
    id: "MSG001",
    type: "Funeral",
    organization: "Alpha Corporation",
    date: "2024-10-20",
    recipients: 150,
    status: "sent",
  },
  {
    id: "MSG002",
    type: "Announcement",
    organization: "Beta Industries",
    date: "2024-10-18",
    recipients: 200,
    status: "sent",
  },
  {
    id: "MSG003",
    type: "Funeral",
    organization: "Gamma Solutions",
    date: "2024-10-15",
    recipients: 120,
    status: "sent",
  },
  {
    id: "MSG004",
    type: "Announcement",
    organization: "Delta Enterprises",
    date: "2024-10-12",
    recipients: 180,
    status: "sent",
  },
  { id: "MSG005", type: "Funeral", organization: "Epsilon Group", date: "2024-10-10", recipients: 95, status: "sent" },
]

export default function MessagesPage() {
  const [searchTerm, setSearchTerm] = useState("")
  const [typeFilter, setTypeFilter] = useState("all")

  const filteredMessages = mockMessages.filter((message) => {
    const matchesSearch =
      message.id.toLowerCase().includes(searchTerm.toLowerCase()) ||
      message.organization.toLowerCase().includes(searchTerm.toLowerCase())
    const matchesType = typeFilter === "all" || message.type.toLowerCase() === typeFilter
    return matchesSearch && matchesType
  })

  return (
    <div className="space-y-6">
      <div>
        <h1 className="text-3xl font-bold tracking-tight">Messages</h1>
        <p className="text-muted-foreground">View and manage all messages in the system</p>
      </div>

      <Card>
        <CardHeader>
          <div className="flex flex-col sm:flex-row gap-4">
            <div className="relative flex-1">
              <Search className="absolute left-3 top-1/2 transform -translate-y-1/2 w-4 h-4 text-muted-foreground" />
              <Input
                placeholder="Search by ID or organization..."
                value={searchTerm}
                onChange={(e) => setSearchTerm(e.target.value)}
                className="pl-9"
              />
            </div>
            <Select value={typeFilter} onValueChange={setTypeFilter}>
              <SelectTrigger className="w-full sm:w-[180px]">
                <SelectValue placeholder="Filter by type" />
              </SelectTrigger>
              <SelectContent>
                <SelectItem value="all">All Types</SelectItem>
                <SelectItem value="funeral">Funeral</SelectItem>
                <SelectItem value="announcement">Announcement</SelectItem>
              </SelectContent>
            </Select>
          </div>
        </CardHeader>
        <CardContent>
          <Table>
            <TableHeader>
              <TableRow>
                <TableHead>Message ID</TableHead>
                <TableHead>Type</TableHead>
                <TableHead>Organization</TableHead>
                <TableHead>Date Sent</TableHead>
                <TableHead>Recipients</TableHead>
                <TableHead>Status</TableHead>
                <TableHead className="text-right">Actions</TableHead>
              </TableRow>
            </TableHeader>
            <TableBody>
              {filteredMessages.map((message) => (
                <TableRow key={message.id}>
                  <TableCell className="font-mono text-sm">{message.id}</TableCell>
                  <TableCell>
                    <Badge variant="outline">{message.type}</Badge>
                  </TableCell>
                  <TableCell>{message.organization}</TableCell>
                  <TableCell>{message.date}</TableCell>
                  <TableCell>{message.recipients}</TableCell>
                  <TableCell>
                    <Badge>{message.status}</Badge>
                  </TableCell>
                  <TableCell className="text-right">
                    <div className="flex justify-end gap-2">
                      <Button variant="ghost" size="icon">
                        <Eye className="w-4 h-4" />
                      </Button>
                      <Button variant="ghost" size="icon">
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

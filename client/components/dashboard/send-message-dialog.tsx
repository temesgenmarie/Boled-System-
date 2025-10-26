"use client"

import type React from "react"

import { useState } from "react"
import { Dialog, DialogContent, DialogDescription, DialogHeader, DialogTitle } from "@/components/ui/dialog"
import { Button } from "@/components/ui/button"
import { Input } from "@/components/ui/input"
import { Textarea } from "@/components/ui/textarea"
import { Select, SelectContent, SelectItem, SelectTrigger, SelectValue } from "@/components/ui/select"

interface SendMessageDialogProps {
  open: boolean
  onOpenChange: (open: boolean) => void
  onSubmit: (data: any) => void
}

export default function SendMessageDialog({ open, onOpenChange, onSubmit }: SendMessageDialogProps) {
  const [type, setType] = useState("announcement")

  const [announcementTitle, setAnnouncementTitle] = useState("")
  const [announcementPlace, setAnnouncementPlace] = useState("")
  const [announcementTime, setAnnouncementTime] = useState("")
  const [announcementContent, setAnnouncementContent] = useState("")

  const [funeralPlace, setFuneralPlace] = useState("")
  const [funeralAddress, setFuneralAddress] = useState("")
  const [deathType, setDeathType] = useState("new")
  const [funeralContent, setFuneralContent] = useState("")

  const handleSubmit = (e: React.FormEvent) => {
    e.preventDefault()

    let payload: any = { type }

    if (type === "announcement") {
      payload = {
        ...payload,
        title: announcementTitle,
        place: announcementPlace,
        time: announcementTime,
        content: announcementContent,
      }
      setAnnouncementTitle("")
      setAnnouncementPlace("")
      setAnnouncementTime("")
      setAnnouncementContent("")
    } else if (type === "funeral") {
      payload = {
        ...payload,
        place: funeralPlace,
        address: funeralAddress,
        deathType,
        content: funeralContent,
      }
      setFuneralPlace("")
      setFuneralAddress("")
      setDeathType("new")
      setFuneralContent("")
    }

    onSubmit(payload)
  }

  const resetForm = () => {
    setAnnouncementTitle("")
    setAnnouncementPlace("")
    setAnnouncementTime("")
    setAnnouncementContent("")
    setFuneralPlace("")
    setFuneralAddress("")
    setDeathType("new")
    setFuneralContent("")
  }

  return (
    <Dialog
      open={open}
      onOpenChange={(newOpen) => {
        if (!newOpen) resetForm()
        onOpenChange(newOpen)
      }}
    >
      <DialogContent className="bg-card border-border max-w-2xl">
        <DialogHeader>
          <DialogTitle>Send Message</DialogTitle>
          <DialogDescription>Send an announcement or funeral notice to members</DialogDescription>
        </DialogHeader>
        <form onSubmit={handleSubmit} className="space-y-4">
          <div className="space-y-2">
            <label className="text-sm font-medium">Message Type</label>
            <Select value={type} onValueChange={setType}>
              <SelectTrigger className="bg-background border-border">
                <SelectValue />
              </SelectTrigger>
              <SelectContent className="bg-card border-border">
                <SelectItem value="announcement">Announcement</SelectItem>
                <SelectItem value="funeral">Funeral Notice</SelectItem>
              </SelectContent>
            </Select>
          </div>

          {type === "announcement" && (
            <>
              <div className="space-y-2">
                <label className="text-sm font-medium">Title</label>
                <Input
                  placeholder="Announcement title"
                  value={announcementTitle}
                  onChange={(e) => setAnnouncementTitle(e.target.value)}
                  required
                  className="bg-background border-border"
                />
              </div>
              <div className="grid grid-cols-2 gap-4">
                <div className="space-y-2">
                  <label className="text-sm font-medium">Place/Location</label>
                  <Input
                    placeholder="Where the event will be held"
                    value={announcementPlace}
                    onChange={(e) => setAnnouncementPlace(e.target.value)}
                    required
                    className="bg-background border-border"
                  />
                </div>
                <div className="space-y-2">
                  <label className="text-sm font-medium">Time</label>
                  <Input
                    type="datetime-local"
                    value={announcementTime}
                    onChange={(e) => setAnnouncementTime(e.target.value)}
                    required
                    className="bg-background border-border"
                  />
                </div>
              </div>
              <div className="space-y-2">
                <label className="text-sm font-medium">Details</label>
                <Textarea
                  placeholder="Write announcement details here..."
                  value={announcementContent}
                  onChange={(e) => setAnnouncementContent(e.target.value)}
                  required
                  className="bg-background border-border min-h-32"
                />
              </div>
            </>
          )}

          {type === "funeral" && (
            <>
              <div className="grid grid-cols-2 gap-4">
                <div className="space-y-2">
                  <label className="text-sm font-medium">Place (Funeral/Church)</label>
                  <Input
                    placeholder="e.g., St. Mary's Church, Funeral Home"
                    value={funeralPlace}
                    onChange={(e) => setFuneralPlace(e.target.value)}
                    required
                    className="bg-background border-border"
                  />
                </div>
                <div className="space-y-2">
                  <label className="text-sm font-medium">Address</label>
                  <Input
                    placeholder="Full address"
                    value={funeralAddress}
                    onChange={(e) => setFuneralAddress(e.target.value)}
                    required
                    className="bg-background border-border"
                  />
                </div>
              </div>
              <div className="space-y-2">
                <label className="text-sm font-medium">Death Type</label>
                <Select value={deathType} onValueChange={setDeathType}>
                  <SelectTrigger className="bg-background border-border">
                    <SelectValue />
                  </SelectTrigger>
                  <SelectContent className="bg-card border-border">
                    <SelectItem value="new">New Death</SelectItem>
                    <SelectItem value="old">Old Death (Anniversary)</SelectItem>
                  </SelectContent>
                </Select>
              </div>
              <div className="space-y-2">
                <label className="text-sm font-medium">Funeral Details</label>
                <Textarea
                  placeholder="Write funeral notice details here..."
                  value={funeralContent}
                  onChange={(e) => setFuneralContent(e.target.value)}
                  required
                  className="bg-background border-border min-h-32"
                />
              </div>
            </>
          )}

          <div className="flex gap-3 justify-end">
            <Button type="button" variant="outline" onClick={() => onOpenChange(false)}>
              Cancel
            </Button>
            <Button type="submit" className="bg-primary hover:bg-primary-hover text-white">
              Send Message
            </Button>
          </div>
        </form>
      </DialogContent>
    </Dialog>
  )
}

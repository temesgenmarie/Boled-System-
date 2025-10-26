import type { Organization, Member, Message, ApiResponse } from "./types"
import {
  mockOrganizations,
  mockMembers,
  mockMessages,
  mockActivities,
  mockKPIData,
  mockMessagesPerOrg,
  mockMessageVolume,
} from "./mock-data"

// Configuration - change API_BASE_URL to switch between demo and real backend
const API_BASE_URL = process.env.NEXT_PUBLIC_API_URL || "http://localhost:3000/api"
const USE_MOCK_DATA = process.env.NEXT_PUBLIC_USE_MOCK_DATA !== "false"

// Helper function for API calls
async function apiCall<T>(endpoint: string, options?: RequestInit): Promise<ApiResponse<T>> {
  try {
    const response = await fetch(`${API_BASE_URL}${endpoint}`, {
      headers: {
        "Content-Type": "application/json",
        ...options?.headers,
      },
      ...options,
    })

    if (!response.ok) {
      throw new Error(`API error: ${response.statusText}`)
    }

    return await response.json()
  } catch (error) {
    console.error("[API Error]", error)
    return {
      success: false,
      error: error instanceof Error ? error.message : "Unknown error",
    }
  }
}

// Organizations API
export const organizationsApi = {
  // Get all organizations
  async getAll(): Promise<Organization[]> {
    if (USE_MOCK_DATA) {
      return mockOrganizations
    }
    const response = await apiCall<Organization[]>("/organizations")
    return response.data || []
  },

  // Get single organization
  async getById(id: string): Promise<Organization | null> {
    if (USE_MOCK_DATA) {
      return mockOrganizations.find((org) => org.id === id) || null
    }
    const response = await apiCall<Organization>(`/organizations/${id}`)
    return response.data || null
  },

  // Create organization
  async create(data: Omit<Organization, "id" | "created">): Promise<Organization | null> {
    if (USE_MOCK_DATA) {
      const newOrg: Organization = {
        ...data,
        id: `ORG${String(mockOrganizations.length + 1).padStart(3, "0")}`,
        created: new Date().toISOString().split("T")[0],
      }
      mockOrganizations.push(newOrg)
      return newOrg
    }
    const response = await apiCall<Organization>("/organizations", {
      method: "POST",
      body: JSON.stringify(data),
    })
    return response.data || null
  },

  // Update organization
  async update(id: string, data: Partial<Organization>): Promise<Organization | null> {
    if (USE_MOCK_DATA) {
      const index = mockOrganizations.findIndex((org) => org.id === id)
      if (index !== -1) {
        mockOrganizations[index] = { ...mockOrganizations[index], ...data }
        return mockOrganizations[index]
      }
      return null
    }
    const response = await apiCall<Organization>(`/organizations/${id}`, {
      method: "PUT",
      body: JSON.stringify(data),
    })
    return response.data || null
  },

  // Delete organization
  async delete(id: string): Promise<boolean> {
    if (USE_MOCK_DATA) {
      const index = mockOrganizations.findIndex((org) => org.id === id)
      if (index !== -1) {
        mockOrganizations.splice(index, 1)
        return true
      }
      return false
    }
    const response = await apiCall(`/organizations/${id}`, { method: "DELETE" })
    return response.success
  },
}

// Members API
export const membersApi = {
  // Get all members
  async getAll(): Promise<Member[]> {
    if (USE_MOCK_DATA) {
      return mockMembers
    }
    const response = await apiCall<Member[]>("/members")
    return response.data || []
  },

  // Get members by organization
  async getByOrganization(orgId: string): Promise<Member[]> {
    if (USE_MOCK_DATA) {
      const org = mockOrganizations.find((o) => o.id === orgId)
      return mockMembers.filter((m) => m.organization === org?.name)
    }
    const response = await apiCall<Member[]>(`/members?organization=${orgId}`)
    return response.data || []
  },

  // Create member
  async create(data: Omit<Member, "id">): Promise<Member | null> {
    if (USE_MOCK_DATA) {
      const newMember: Member = {
        ...data,
        id: `MEM${String(mockMembers.length + 1).padStart(3, "0")}`,
      }
      mockMembers.push(newMember)
      return newMember
    }
    const response = await apiCall<Member>("/members", {
      method: "POST",
      body: JSON.stringify(data),
    })
    return response.data || null
  },

  // Update member
  async update(id: string, data: Partial<Member>): Promise<Member | null> {
    if (USE_MOCK_DATA) {
      const index = mockMembers.findIndex((m) => m.id === id)
      if (index !== -1) {
        mockMembers[index] = { ...mockMembers[index], ...data }
        return mockMembers[index]
      }
      return null
    }
    const response = await apiCall<Member>(`/members/${id}`, {
      method: "PUT",
      body: JSON.stringify(data),
    })
    return response.data || null
  },

  // Delete member
  async delete(id: string): Promise<boolean> {
    if (USE_MOCK_DATA) {
      const index = mockMembers.findIndex((m) => m.id === id)
      if (index !== -1) {
        mockMembers.splice(index, 1)
        return true
      }
      return false
    }
    const response = await apiCall(`/members/${id}`, { method: "DELETE" })
    return response.success
  },
}

// Messages API
export const messagesApi = {
  // Get all messages
  async getAll(): Promise<Message[]> {
    if (USE_MOCK_DATA) {
      return mockMessages
    }
    const response = await apiCall<Message[]>("/messages")
    return response.data || []
  },

  // Get messages by organization
  async getByOrganization(orgId: string): Promise<Message[]> {
    if (USE_MOCK_DATA) {
      return mockMessages.filter((m) => m.organizationId === orgId)
    }
    const response = await apiCall<Message[]>(`/messages?organization=${orgId}`)
    return response.data || []
  },

  // Delete message
  async delete(id: string): Promise<boolean> {
    if (USE_MOCK_DATA) {
      const index = mockMessages.findIndex((m) => m.id === id)
      if (index !== -1) {
        mockMessages.splice(index, 1)
        return true
      }
      return false
    }
    const response = await apiCall(`/messages/${id}`, { method: "DELETE" })
    return response.success
  },
}

// Analytics API
export const analyticsApi = {
  // Get KPI data
  async getKPIs() {
    if (USE_MOCK_DATA) {
      return mockKPIData
    }
    const response = await apiCall("/analytics/kpis")
    return response.data || mockKPIData
  },

  // Get messages per organization
  async getMessagesPerOrg() {
    if (USE_MOCK_DATA) {
      return mockMessagesPerOrg
    }
    const response = await apiCall("/analytics/messages-per-org")
    return response.data || mockMessagesPerOrg
  },

  // Get message volume
  async getMessageVolume() {
    if (USE_MOCK_DATA) {
      return mockMessageVolume
    }
    const response = await apiCall("/analytics/message-volume")
    return response.data || mockMessageVolume
  },

  // Get activities
  async getActivities() {
    if (USE_MOCK_DATA) {
      return mockActivities
    }
    const response = await apiCall("/analytics/activities")
    return response.data || mockActivities
  },
}

export const authApi = {
  async login(email: string, password: string) {
    const response = await apiCall("/auth/login", {
      method: "POST",
      body: JSON.stringify({ email, password }),
    })
    return response.data || null
  },

  async logout() {
    const response = await apiCall("/auth/logout", { method: "POST" })
    return response.success
  },

  async changePassword(currentPassword: string, newPassword: string, confirmPassword: string) {
    const response = await apiCall("/auth/change-password", {
      method: "POST",
      body: JSON.stringify({ currentPassword, newPassword, confirmPassword }),
    })
    return response.success
  },
}

export const profileApi = {
  async getProfile() {
    const response = await apiCall("/profile")
    return response.data || null
  },

  async updateProfile(data: Record<string, unknown>) {
    const response = await apiCall("/profile", {
      method: "PUT",
      body: JSON.stringify(data),
    })
    return response.data || null
  },
}

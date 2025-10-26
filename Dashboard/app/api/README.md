# Superadmin Dashboard API Documentation

This document outlines all available API endpoints for the Superadmin Dashboard.

## Base URL
- Development: `http://localhost:3000/api`
- Production: Set via `NEXT_PUBLIC_API_URL` environment variable

## Authentication
Currently using demo authentication. Replace with your auth system.

### Demo Credentials
- Email: `admin@superadmin.com`
- Password: `admin123`

---

## Endpoints

### Organizations

#### GET /organizations
Fetch all organizations
\`\`\`json
Response: {
  "success": true,
  "data": [Organization]
}
\`\`\`

#### POST /organizations
Create a new organization
\`\`\`json
Body: {
  "name": "string",
  "email": "string",
  "password": "string",
  "address": "string",
  "status": "active" | "inactive"
}
Response: {
  "success": true,
  "data": Organization,
  "message": "Organization created successfully"
}
\`\`\`

#### GET /organizations/:id
Fetch a specific organization
\`\`\`json
Response: {
  "success": true,
  "data": Organization
}
\`\`\`

#### PUT /organizations/:id
Update an organization
\`\`\`json
Body: {
  "name": "string",
  "email": "string",
  "address": "string",
  "status": "active" | "inactive"
}
Response: {
  "success": true,
  "data": Organization,
  "message": "Organization updated successfully"
}
\`\`\`

#### DELETE /organizations/:id
Delete an organization
\`\`\`json
Response: {
  "success": true,
  "message": "Organization deleted successfully"
}
\`\`\`

---

### Members

#### GET /members
Fetch all members
\`\`\`json
Response: {
  "success": true,
  "data": [Member]
}
\`\`\`

#### GET /members?organization=orgId
Fetch members by organization
\`\`\`json
Response: {
  "success": true,
  "data": [Member]
}
\`\`\`

#### POST /members
Create a new member
\`\`\`json
Body: {
  "name": "string",
  "email": "string",
  "organization": "string",
  "role": "admin" | "member" | "viewer",
  "status": "active" | "inactive"
}
Response: {
  "success": true,
  "data": Member,
  "message": "Member created successfully"
}
\`\`\`

#### GET /members/:id
Fetch a specific member
\`\`\`json
Response: {
  "success": true,
  "data": Member
}
\`\`\`

#### PUT /members/:id
Update a member
\`\`\`json
Body: {
  "name": "string",
  "email": "string",
  "role": "admin" | "member" | "viewer",
  "status": "active" | "inactive"
}
Response: {
  "success": true,
  "data": Member,
  "message": "Member updated successfully"
}
\`\`\`

#### DELETE /members/:id
Delete a member
\`\`\`json
Response: {
  "success": true,
  "message": "Member deleted successfully"
}
\`\`\`

---

### Messages

#### GET /messages
Fetch all messages
\`\`\`json
Response: {
  "success": true,
  "data": [Message]
}
\`\`\`

#### GET /messages?organization=orgId
Fetch messages by organization
\`\`\`json
Response: {
  "success": true,
  "data": [Message]
}
\`\`\`

#### DELETE /messages/:id
Delete a message
\`\`\`json
Response: {
  "success": true,
  "message": "Message deleted successfully"
}
\`\`\`

---

### Analytics

#### GET /analytics/kpis
Fetch KPI data
\`\`\`json
Response: {
  "success": true,
  "data": {
    "totalOrganizations": number,
    "totalMembers": number,
    "totalMessages": number,
    "activeUsers": number
  }
}
\`\`\`

#### GET /analytics/messages-per-org
Fetch messages per organization
\`\`\`json
Response: {
  "success": true,
  "data": [
    {
      "name": "string",
      "value": number
    }
  ]
}
\`\`\`

#### GET /analytics/message-volume
Fetch message volume over time
\`\`\`json
Response: {
  "success": true,
  "data": [
    {
      "date": "string",
      "messages": number
    }
  ]
}
\`\`\`

#### GET /analytics/activities
Fetch activity logs
\`\`\`json
Response: {
  "success": true,
  "data": [Activity]
}
\`\`\`

---

### Authentication

#### POST /auth/login
Login user
\`\`\`json
Body: {
  "email": "string",
  "password": "string"
}
Response: {
  "success": true,
  "data": {
    "id": "string",
    "email": "string",
    "name": "string",
    "role": "string",
    "token": "string"
  }
}
\`\`\`

#### POST /auth/logout
Logout user
\`\`\`json
Response: {
  "success": true,
  "message": "Logout successful"
}
\`\`\`

#### POST /auth/change-password
Change password
\`\`\`json
Body: {
  "currentPassword": "string",
  "newPassword": "string",
  "confirmPassword": "string"
}
Response: {
  "success": true,
  "message": "Password changed successfully"
}
\`\`\`

---

### Profile

#### GET /profile
Fetch current user profile
\`\`\`json
Response: {
  "success": true,
  "data": {
    "id": "string",
    "email": "string",
    "name": "string",
    "role": "string",
    "status": "string",
    "joinDate": "string",
    "lastLogin": "string",
    "permissions": [string]
  }
}
\`\`\`

#### PUT /profile
Update user profile
\`\`\`json
Body: {
  "name": "string",
  "email": "string"
}
Response: {
  "success": true,
  "data": Profile,
  "message": "Profile updated successfully"
}
\`\`\`

---

## Error Handling

All endpoints return error responses in the following format:
\`\`\`json
{
  "success": false,
  "error": "Error message"
}
\`\`\`

Common HTTP Status Codes:
- `200`: Success
- `201`: Created
- `400`: Bad Request
- `401`: Unauthorized
- `404`: Not Found
- `500`: Server Error

---

## Integration with Backend

To integrate with your real backend:

1. Update `NEXT_PUBLIC_API_URL` environment variable to point to your backend
2. Set `NEXT_PUBLIC_USE_MOCK_DATA=false` to disable mock data
3. Replace TODO comments in route handlers with real database queries
4. Implement proper authentication and authorization
5. Add input validation and error handling

---

## Mock Data

Mock data is stored in `lib/mock-data.ts` and is used when `NEXT_PUBLIC_USE_MOCK_DATA` is not set to `false`.

To switch between mock and real data:
- Mock: `NEXT_PUBLIC_USE_MOCK_DATA=true` (default)
- Real: `NEXT_PUBLIC_USE_MOCK_DATA=false`

interface ApiResponse<T> {
  data?: T
  error?: string
  status: number
}

export async function apiCall<T>(url: string, options?: RequestInit): Promise<ApiResponse<T>> {
  try {
    const response = await fetch(url, {
      headers: {
        "Content-Type": "application/json",
        ...options?.headers,
      },
      ...options,
    })

    const data = await response.json()

    if (!response.ok) {
      return {
        error: data.error || "An error occurred",
        status: response.status,
      }
    }

    return {
      data,
      status: response.status,
    }
  } catch (error) {
    return {
      error: error instanceof Error ? error.message : "An unexpected error occurred",
      status: 500,
    }
  }
}

export async function apiGet<T>(url: string): Promise<ApiResponse<T>> {
  return apiCall<T>(url, { method: "GET" })
}

export async function apiPost<T>(url: string, body: any): Promise<ApiResponse<T>> {
  return apiCall<T>(url, {
    method: "POST",
    body: JSON.stringify(body),
  })
}

export async function apiPut<T>(url: string, body: any): Promise<ApiResponse<T>> {
  return apiCall<T>(url, {
    method: "PUT",
    body: JSON.stringify(body),
  })
}

export async function apiDelete<T>(url: string): Promise<ApiResponse<T>> {
  return apiCall<T>(url, { method: "DELETE" })
}

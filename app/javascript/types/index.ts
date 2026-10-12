import type { ComponentType, ReactNode } from 'react'

export type FlashData = {
  notice?: string
  alert?: string
}

export type SharedProps = {
  flash?: FlashData
  react_layout?: ReactLayoutName
  page_title?: string | null
  breadcrumbs?: BreadcrumbItem[]
  auth?: {
    user?: {
      id: number
      email: string
      name: string | null
      username: string | null
      role: string | null
      status: string | null
    } | null
  }
}

export type ReactLayoutName = 'application' | 'admin' | 'fullscreen' | 'workspace'

export type BreadcrumbItem = {
  label: string
  href?: string | null
}

export type SelectOption = {
  value: string
  label: string
}

export type AdminUser = {
  id: number
  email: string
  name: string
  username: string
  role: string
  role_key?: string
  status: string
  created_at: string
}

export type AdminUserFormValues = {
  id?: number
  email: string
  name: string
  username: string
  role: string
  role_id: string
  status: string
}

export type AdminUserSearch = {
  email_or_name_or_username_cont?: string
  role_id_eq?: string
  status_eq?: string
}

export type AdminUserFilters = {
  q: AdminUserSearch
}

export type AdminUsersOverview = {
  total: number
  matching: number
  active: number
  inactive: number
  admins: number
}

export type PaginationData = {
  page: number
  pages: number
  count: number
  from: number | null
  to: number | null
  prev: number | null
  next: number | null
}

export type InertiaPageComponent<P = Record<string, unknown>> = ComponentType<P> & {
  layout?: (page: ReactNode) => ReactNode
}

export type AdminDashboardStats = {
  total_users: number
  active_users: number
  inactive_users: number
  admin_users: number
  new_users_last_7_days: number
}

export type AdminDashboardBreakdownItem = {
  label: string
  value: string
  count: number
  percentage: number
}

export type AdminDashboardAttentionItem = {
  label: string
  value: number
  description: string
}

export type AdminSettingsUser = {
  id: number
  email: string
  name: string
  username: string
  avatar_url?: string | null
}

export type AdminSettingsProfileFormData = {
  name: string
  username: string
  avatar: File | null
}

export type AdminSettingsAccountFormData = {
  name: string
  email: string
}

export type AdminSettingsTheme = 'light' | 'dark' | 'system'

export type AdminSettingsAppearanceFormData = {
  theme: AdminSettingsTheme
}

export type AdminNotificationType = 'all' | 'mentions' | 'none'

export type AdminSettingsValues = {
  theme?: AdminSettingsTheme | null
  notification_type?: AdminNotificationType | null
  notify_communication_emails?: boolean | null
  notify_marketing_emails?: boolean | null
  notify_social_emails?: boolean | null
  notify_security_emails?: boolean | null
  notify_mobile_push?: boolean | null
}

export type AdminSettingsNotificationsFormData = {
  notification_type: AdminNotificationType
  notify_communication_emails: boolean
  notify_marketing_emails: boolean
  notify_social_emails: boolean
  notify_security_emails: boolean
  notify_mobile_push: boolean
}

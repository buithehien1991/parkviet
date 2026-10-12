import { Link, usePage } from '@inertiajs/react'

import {
  Breadcrumb,
  BreadcrumbItem,
  BreadcrumbLink,
  BreadcrumbList,
  BreadcrumbPage,
  BreadcrumbSeparator,
} from '@/components/ui/breadcrumb'
import type { BreadcrumbItem as SharedBreadcrumbItem, SharedProps } from '@/types'

type BreadcrumbSegment = {
  href?: string
  label: string
}

const segmentLabels: Record<string, string> = {
  admin: 'Admin',
  users: 'Users',
  new: 'Create User',
  edit: 'Edit User',
  settings: 'Settings',
  profile: 'Profile',
  account: 'Account',
  appearance: 'Appearance',
  notifications: 'Notifications',
}

function buildSegments(pathname: string) {
  const parts = pathname.split('/').filter(Boolean)
  const segments: BreadcrumbSegment[] = []

  if (parts[0] !== 'admin') {
    return segments
  }

  let href = ''

  parts.forEach((part, index) => {
    href += `/${part}`

    if (/^\d+$/.test(part)) {
      return
    }

    segments.push({
      href: index === parts.length - 1 ? undefined : href,
      label: segmentLabels[part] ?? part.replace(/-/g, ' ').replace(/\b\w/g, (letter) => letter.toUpperCase()),
    })
  })

  return segments
}

export function AdminBreadcrumbs() {
  const page = usePage<SharedProps>()
  const currentPath = page.url.split('?')[0]
  const sharedBreadcrumbs = page.props.breadcrumbs
  const segments = sharedBreadcrumbs?.length ? normalizeBreadcrumbs(sharedBreadcrumbs) : buildSegments(currentPath)

  if (segments.length === 0) {
    return null
  }

  return (
    <Breadcrumb>
      <BreadcrumbList>
        {segments.map((segment, index) => (
          <BreadcrumbItem key={`${segment.label}-${segment.href ?? 'current'}`}>
            {segment.href ? (
              <BreadcrumbLink render={<Link href={segment.href} />}>{segment.label}</BreadcrumbLink>
            ) : (
              <BreadcrumbPage>{segment.label}</BreadcrumbPage>
            )}
            {index < segments.length - 1 ? <BreadcrumbSeparator /> : null}
          </BreadcrumbItem>
        ))}
      </BreadcrumbList>
    </Breadcrumb>
  )
}

function normalizeBreadcrumbs(items: SharedBreadcrumbItem[]) {
  return items.map((item) => ({
    label: item.label,
    href: item.href ?? undefined,
  }))
}

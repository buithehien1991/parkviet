import { Link, router, usePage } from '@inertiajs/react'
import { Bell, Palette, UserCog, Wrench, type LucideIcon } from 'lucide-react'
import type { ReactNode } from 'react'

import { AdminPageHeader } from '@/components/admin/admin-page-header'
import { buttonVariants } from '@/components/ui/button'
import {
  Select,
  SelectContent,
  SelectItem,
  SelectTrigger,
  SelectValue,
} from '@/components/ui/select'
import { Separator } from '@/components/ui/separator'
import { cn } from '@/lib/utils'

type SettingsNavItem = {
  title: string
  href: string
  icon: LucideIcon
}

const settingsNavItems: SettingsNavItem[] = [
  { title: 'Profile', href: '/admin/settings/profile', icon: UserCog },
  { title: 'Account', href: '/admin/settings/account', icon: Wrench },
  { title: 'Appearance', href: '/admin/settings/appearance', icon: Palette },
  { title: 'Notifications', href: '/admin/settings/notifications', icon: Bell },
]

type SettingsLayoutProps = {
  children: ReactNode
}

export function SettingsLayout({ children }: SettingsLayoutProps) {
  const page = usePage()
  const currentPath = normalizeSettingsPath(page.url.split('?')[0])

  return (
    <>
      <AdminPageHeader
        title="Settings"
        description="Manage your account preferences and workspace experience."
        eyebrow="Admin / Settings"
      />

      <div className="flex flex-1 flex-col p-4 sm:p-6">
        <div className="md:hidden">
          <Select
            value={currentPath}
            onValueChange={(value) => {
              if (value && value !== currentPath) {
                router.visit(value)
              }
            }}
          >
            <SelectTrigger aria-label="Settings navigation" className="w-full">
              <SelectValue placeholder="Select a settings section" />
            </SelectTrigger>
            <SelectContent>
              {settingsNavItems.map((item) => (
                <SelectItem key={item.href} value={item.href}>
                  <span className="flex items-center gap-2">
                    <item.icon className="size-4" aria-hidden="true" />
                    <span>{item.title}</span>
                  </span>
                </SelectItem>
              ))}
            </SelectContent>
          </Select>
        </div>

        <Separator className="my-4 md:hidden" />

        <div className="flex flex-1 flex-col space-y-2 md:flex-row md:space-y-0 md:space-x-12 lg:space-x-12">
          <aside className="hidden md:block md:w-1/5 lg:w-1/5">
            <nav className="flex flex-col gap-1" aria-label="Settings sub-navigation">
              {settingsNavItems.map((item) => {
                const isActive = currentPath === item.href
                return (
                  <Link
                    key={item.href}
                    href={item.href}
                    className={cn(
                      buttonVariants({ variant: 'ghost' }),
                      'justify-start gap-2',
                      isActive
                        ? 'bg-muted hover:bg-muted'
                        : 'hover:bg-transparent hover:underline'
                    )}
                  >
                    <item.icon className="size-4" aria-hidden="true" />
                    {item.title}
                  </Link>
                )
              })}
            </nav>
          </aside>

          <div className="flex flex-1 flex-col">{children}</div>
        </div>
      </div>
    </>
  )
}

function normalizeSettingsPath(path: string) {
  if (path === '/admin/settings' || path === '/admin/settings/') {
    return '/admin/settings/profile'
  }
  return path.replace(/\/$/, '')
}

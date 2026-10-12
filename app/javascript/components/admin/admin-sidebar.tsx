import { Link, router, usePage } from '@inertiajs/react'
import { BadgeCheck, ChevronsUpDown, CreditCard, LayoutDashboard, LogOut, Plus, Settings, Shield, Users } from 'lucide-react'

import { Avatar, AvatarFallback } from '@/components/ui/avatar'
import {
  DropdownMenu,
  DropdownMenuContent,
  DropdownMenuGroup,
  DropdownMenuItem,
  DropdownMenuLabel,
  DropdownMenuSeparator,
  DropdownMenuTrigger,
} from '@/components/ui/dropdown-menu'
import {
  Sidebar,
  SidebarContent,
  SidebarFooter,
  SidebarGroup,
  SidebarGroupContent,
  SidebarGroupLabel,
  SidebarHeader,
  SidebarMenu,
  SidebarMenuBadge,
  SidebarMenuButton,
  SidebarMenuItem,
  SidebarRail,
  SidebarSeparator,
} from '@/components/ui/sidebar'
import type { SharedProps } from '@/types'

const navigationItems = [
  {
    title: 'Dashboard',
    href: '/admin',
    icon: LayoutDashboard,
    description: 'Overview and key signals',
  },
  {
    title: 'Users',
    href: '/admin/users',
    icon: Users,
    description: 'Accounts, roles, and status',
  },
  {
    title: 'Settings',
    href: '/admin/settings/profile',
    icon: Settings,
    description: 'Profile, account, and preferences',
  },
]

function userInitials(name?: string | null, email?: string | null) {
  const source = name?.trim() || email?.trim() || 'A'
  const words = source.split(/\s+/).filter(Boolean)

  if (words.length === 1) {
    return words[0].slice(0, 2).toUpperCase()
  }

  return words.slice(0, 2).map((word) => word[0]).join('').toUpperCase()
}

export function AdminSidebar() {
  const page = usePage<SharedProps>()
  const currentPath = page.url.split('?')[0]
  const user = page.props.auth?.user
  const displayName = user?.name || user?.username || 'Admin'
  const identityLabel = user?.email || 'Admin workspace'
  const roleLabel = user?.role || 'admin'

  return (
    <Sidebar collapsible="icon" variant="inset">
      <SidebarHeader>
        <div className="flex min-h-12 items-center gap-3 overflow-hidden px-2 py-1 group-data-[collapsible=icon]:justify-center group-data-[collapsible=icon]:px-0">
          <div className="flex size-8 shrink-0 items-center justify-center rounded-xl bg-sidebar-primary text-sidebar-primary-foreground shadow-sm">
            <Shield className="size-4" aria-hidden="true" />
          </div>
          <div className="min-w-0 group-data-[collapsible=icon]:hidden">
            <p className="truncate text-sm font-semibold text-sidebar-foreground">Admin Console</p>
            <p className="truncate text-xs text-sidebar-foreground/70">Operations</p>
          </div>
        </div>
      </SidebarHeader>

      <SidebarContent>
        <SidebarGroup>
          <SidebarGroupLabel>Navigation</SidebarGroupLabel>
          <SidebarGroupContent>
            <SidebarMenu>
              {navigationItems.map((item) => {
                const isActive = item.href === '/admin'
                  ? currentPath === '/admin'
                  : item.href.startsWith('/admin/settings')
                    ? currentPath.startsWith('/admin/settings')
                    : currentPath.startsWith(item.href)

                return (
                  <SidebarMenuItem key={item.href}>
                    <SidebarMenuButton
                      render={<Link href={item.href} />}
                      isActive={isActive}
                      tooltip={item.title}
                      className="h-10 rounded-xl"
                    >
                      <item.icon />
                      <span className="truncate">{item.title}</span>
                      {item.href === '/admin/users' ? <SidebarMenuBadge>Core</SidebarMenuBadge> : null}
                    </SidebarMenuButton>
                  </SidebarMenuItem>
                )
              })}
            </SidebarMenu>
          </SidebarGroupContent>
        </SidebarGroup>

        <SidebarSeparator />

        <SidebarGroup>
          <SidebarGroupLabel>Quick Actions</SidebarGroupLabel>
          <SidebarGroupContent>
            <SidebarMenu>
              <SidebarMenuItem>
                <SidebarMenuButton
                  render={<Link href="/admin/users/new" />}
                  tooltip="Create User"
                  className="h-10 rounded-xl"
                >
                  <Plus />
                  <span>Create User</span>
                </SidebarMenuButton>
              </SidebarMenuItem>
            </SidebarMenu>
          </SidebarGroupContent>
        </SidebarGroup>
      </SidebarContent>

      <SidebarFooter>
        <SidebarMenu>
          <SidebarMenuItem>
            <DropdownMenu>
              <DropdownMenuTrigger
                render={
                  <SidebarMenuButton
                    size="lg"
                    className="rounded-xl data-[open]:bg-sidebar-accent data-[open]:text-sidebar-accent-foreground"
                    tooltip={displayName}
                  />
                }
              >
                <Avatar className="h-8 w-8 rounded-lg">
                  <AvatarFallback className="rounded-lg">
                    {userInitials(user?.name, user?.email)}
                  </AvatarFallback>
                </Avatar>
                <div className="grid flex-1 min-w-0 text-left text-sm leading-tight group-data-[collapsible=icon]:hidden">
                  <span className="truncate font-semibold">{displayName}</span>
                  <span className="truncate text-xs text-sidebar-foreground/70">{identityLabel}</span>
                </div>
                <ChevronsUpDown className="ml-auto size-4 group-data-[collapsible=icon]:hidden" aria-hidden="true" />
              </DropdownMenuTrigger>

                <DropdownMenuContent
                  side="right"
                  align="end"
                  className="min-w-56 rounded-lg"
                >
                <DropdownMenuGroup>
                  <DropdownMenuLabel className="p-0 font-normal">
                    <div className="flex items-center gap-2 px-1 py-1.5 text-left text-sm">
                      <Avatar className="h-8 w-8 rounded-lg">
                        <AvatarFallback className="rounded-lg">
                          {userInitials(user?.name, user?.email)}
                        </AvatarFallback>
                      </Avatar>
                      <div className="grid min-w-0 flex-1 text-left text-sm leading-tight">
                        <span className="truncate font-semibold">{displayName}</span>
                        <span className="truncate text-xs text-muted-foreground">{identityLabel}</span>
                      </div>
                    </div>
                  </DropdownMenuLabel>
                </DropdownMenuGroup>
                <DropdownMenuSeparator />
                <DropdownMenuGroup>
                  <DropdownMenuItem onClick={() => router.visit('/users/edit')}>
                    <BadgeCheck className="size-4" aria-hidden="true" />
                    Account
                  </DropdownMenuItem>
                  <DropdownMenuItem disabled>
                    <CreditCard className="size-4" aria-hidden="true" />
                    Signed in as {roleLabel}
                  </DropdownMenuItem>
                </DropdownMenuGroup>
                <DropdownMenuSeparator />
                <DropdownMenuItem
                  variant="destructive"
                  onClick={() => router.delete('/users/sign_out')}
                >
                  <LogOut className="size-4" aria-hidden="true" />
                  Sign Out
                </DropdownMenuItem>
              </DropdownMenuContent>
            </DropdownMenu>
          </SidebarMenuItem>
        </SidebarMenu>
      </SidebarFooter>
      <SidebarRail />
    </Sidebar>
  )
}

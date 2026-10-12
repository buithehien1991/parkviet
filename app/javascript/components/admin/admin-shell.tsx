import type { ReactNode } from 'react'

import { AdminBreadcrumbs } from '@/components/admin/admin-breadcrumbs'
import { AdminCommandMenu } from '@/components/admin/admin-command-menu'
import { AdminSidebar } from '@/components/admin/admin-sidebar'
import { SidebarInset, SidebarProvider, SidebarTrigger } from '@/components/ui/sidebar'

type AdminShellProps = {
  children: ReactNode
}

export function AdminShell({ children }: AdminShellProps) {
  return (
    <SidebarProvider>
      <a
        href="#admin-content"
        className="sr-only z-50 rounded-md bg-background px-3 py-2 text-sm font-medium text-foreground shadow-sm ring-1 ring-border focus:not-sr-only focus:fixed focus:top-4 focus:left-4"
      >
        Skip to main content
      </a>
      <AdminSidebar />
      <SidebarInset className="overflow-hidden border border-sidebar-border/60 bg-background/95 md:min-h-[calc(100svh-1rem)]">
        <div className="sticky top-0 z-30 border-b border-border/70 bg-background/90 backdrop-blur supports-backdrop-filter:bg-background/75">
          <div className="flex h-16 items-center gap-3 px-4 sm:px-6">
            <SidebarTrigger aria-label="Toggle admin sidebar" />
            <div className="min-w-0 flex-1">
              <AdminBreadcrumbs />
            </div>
            <AdminCommandMenu />
          </div>
        </div>
        <div id="admin-content" className="flex flex-1 flex-col">
          {children}
        </div>
      </SidebarInset>
    </SidebarProvider>
  )
}

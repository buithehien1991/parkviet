import { Head } from '@inertiajs/react'

import { AdminPageHeader } from '@/components/admin/admin-page-header'
import { DashboardStatCard } from '@/components/admin/dashboard/dashboard-stat-card'
import { RecentUsersList } from '@/components/admin/dashboard/recent-users-list'
import { StatusBreakdownPanel } from '@/components/admin/dashboard/status-breakdown-panel'
import { Card, CardContent, CardDescription, CardHeader, CardTitle } from '@/components/ui/card'
import type { AdminDashboardAttentionItem, AdminDashboardBreakdownItem, AdminDashboardStats, AdminUser } from '@/types'

type Props = {
  stats: AdminDashboardStats
  status_breakdown: AdminDashboardBreakdownItem[]
  recent_users: AdminUser[]
  attention: AdminDashboardAttentionItem[]
}

export default function AdminDashboardIndex({ stats, status_breakdown, recent_users, attention }: Props) {
  return (
    <>
      <Head title="Admin Dashboard" />

      <AdminPageHeader
        title="Dashboard"
        description="Operational overview for admin users."
      />

      <div className="space-y-6 p-4 sm:p-6">
        <div className="grid gap-4 md:grid-cols-2 xl:grid-cols-4">
          <DashboardStatCard label="Total users" value={stats.total_users} description="Current total accounts in the system." />
          <DashboardStatCard label="Active users" value={stats.active_users} description="Accounts allowed to sign in." />
          <DashboardStatCard label="Admins" value={stats.admin_users} description="Users with admin-level access." />
          <DashboardStatCard label="New this week" value={stats.new_users_last_7_days} description="Accounts created in the last 7 days." />
        </div>

        <div className="grid gap-6 xl:grid-cols-[minmax(0,1fr)_380px]">
          <RecentUsersList users={recent_users} />
          <div className="space-y-6">
            <StatusBreakdownPanel items={status_breakdown} />
            <Card>
              <CardHeader>
                <CardTitle>Attention queue</CardTitle>
                <CardDescription>Current account areas worth scanning before routine operations.</CardDescription>
              </CardHeader>
              <CardContent className="space-y-3">
                {attention.map((item) => (
                  <div key={item.label} className="rounded-lg border bg-muted/20 p-3">
                    <div className="flex items-start justify-between gap-3">
                      <div className="space-y-1">
                        <p className="font-medium">{item.label}</p>
                        <p className="text-sm text-muted-foreground">{item.description}</p>
                      </div>
                      <p className="text-xl font-semibold tabular-nums">{item.value.toLocaleString()}</p>
                    </div>
                  </div>
                ))}
              </CardContent>
            </Card>
          </div>
        </div>
      </div>
    </>
  )
}

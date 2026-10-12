import { Card, CardContent } from '@/components/ui/card'
import type { AdminUsersOverview } from '@/types'

type UsersOverviewStripProps = {
  overview: AdminUsersOverview
}

export function UsersOverviewStrip({ overview }: UsersOverviewStripProps) {
  const items = [
    { label: 'Total users', value: overview.total, hint: 'All accounts' },
    { label: 'Matching', value: overview.matching, hint: 'Current view' },
    { label: 'Active', value: overview.active, hint: 'Can sign in' },
    { label: 'Inactive', value: overview.inactive, hint: 'Access blocked' },
    { label: 'Admins', value: overview.admins, hint: 'Privileged' },
  ]

  return (
    <div className="grid gap-3 sm:grid-cols-2 xl:grid-cols-5">
      {items.map((item) => (
        <Card key={item.label} size="sm">
          <CardContent className="space-y-1">
            <p className="text-xs font-medium uppercase tracking-[0.14em] text-muted-foreground">{item.label}</p>
            <div className="flex items-baseline justify-between gap-3">
              <p className="text-2xl font-semibold tracking-tight">{item.value.toLocaleString()}</p>
              <p className="text-xs text-muted-foreground">{item.hint}</p>
            </div>
          </CardContent>
        </Card>
      ))}
    </div>
  )
}

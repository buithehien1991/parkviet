import { Card, CardContent, CardDescription, CardHeader, CardTitle } from '@/components/ui/card'
import { Progress } from '@/components/ui/progress'
import type { AdminDashboardBreakdownItem } from '@/types'

type StatusBreakdownPanelProps = {
  items: AdminDashboardBreakdownItem[]
}

export function StatusBreakdownPanel({ items }: StatusBreakdownPanelProps) {
  return (
    <Card>
      <CardHeader>
        <CardTitle>Status breakdown</CardTitle>
        <CardDescription>Account availability by current user status.</CardDescription>
      </CardHeader>
      <CardContent className="space-y-4">
        {items.map((item) => (
          <div key={item.value} className="space-y-2">
            <div className="flex items-center justify-between gap-3 text-sm">
              <span className="font-medium">{item.label}</span>
              <span className="text-muted-foreground">{item.count.toLocaleString()} users</span>
            </div>
            <Progress value={item.percentage} />
          </div>
        ))}
      </CardContent>
    </Card>
  )
}

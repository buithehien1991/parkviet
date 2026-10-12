import { Link } from '@inertiajs/react'

import { Avatar, AvatarFallback } from '@/components/ui/avatar'
import { Badge } from '@/components/ui/badge'
import { Button } from '@/components/ui/button'
import { Card, CardContent, CardDescription, CardHeader, CardTitle } from '@/components/ui/card'
import { Empty, EmptyDescription, EmptyHeader, EmptyMedia, EmptyTitle } from '@/components/ui/empty'
import type { AdminUser } from '@/types'

type RecentUsersListProps = {
  users: AdminUser[]
}

export function RecentUsersList({ users }: RecentUsersListProps) {
  return (
    <Card>
      <CardHeader>
        <CardTitle>Recent users</CardTitle>
        <CardDescription>Newest accounts created in this workspace.</CardDescription>
      </CardHeader>
      <CardContent>
        {users.length > 0 ? (
          <div className="divide-y rounded-lg border">
            {users.map((user) => (
              <div key={user.id} className="flex items-center gap-3 p-3">
                <Avatar>
                  <AvatarFallback>{userInitials(user)}</AvatarFallback>
                </Avatar>
                <div className="min-w-0 flex-1 space-y-1">
                  <p className="truncate font-medium">{user.name || 'Unnamed user'}</p>
                  <p className="truncate text-sm text-muted-foreground">{user.email}</p>
                </div>
                <Badge variant={user.status === 'active' ? 'secondary' : 'destructive'} className="capitalize">
                  {user.status}
                </Badge>
                <Button
                  variant="ghost"
                  size="sm"
                  nativeButton={false}
                  render={<Link href={`/admin/users/${user.id}/edit`} />}
                >
                  Review
                </Button>
              </div>
            ))}
          </div>
        ) : (
          <Empty className="border py-10">
            <EmptyHeader>
              <EmptyMedia variant="icon" />
              <EmptyTitle>No recent users</EmptyTitle>
              <EmptyDescription>Newly created accounts will appear here.</EmptyDescription>
            </EmptyHeader>
          </Empty>
        )}
      </CardContent>
    </Card>
  )
}

function userInitials(user: AdminUser) {
  const source = user.name || user.email

  return source
    .split(/\s+|@/)
    .filter(Boolean)
    .slice(0, 2)
    .map((part) => part[0]?.toUpperCase())
    .join('')
}

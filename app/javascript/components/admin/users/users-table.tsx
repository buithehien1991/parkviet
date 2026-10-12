import { Link } from '@inertiajs/react'
import { MoreHorizontal, SearchX, Users } from 'lucide-react'

import { Avatar, AvatarFallback } from '@/components/ui/avatar'
import { Badge } from '@/components/ui/badge'
import { Button } from '@/components/ui/button'
import {
  DropdownMenu,
  DropdownMenuContent,
  DropdownMenuGroup,
  DropdownMenuItem,
  DropdownMenuLabel,
  DropdownMenuSeparator,
  DropdownMenuTrigger,
} from '@/components/ui/dropdown-menu'
import { Empty, EmptyDescription, EmptyHeader, EmptyMedia, EmptyTitle } from '@/components/ui/empty'
import {
  Table,
  TableBody,
  TableCell,
  TableHead,
  TableHeader,
  TableRow,
} from '@/components/ui/table'
import type { AdminUser } from '@/types'

type UsersTableProps = {
  users: AdminUser[]
  hasFilters: boolean
  onDelete: (user: AdminUser) => void
}

export function UsersTable({ users, hasFilters, onDelete }: UsersTableProps) {
  if (users.length === 0) {
    return <UsersEmptyState hasFilters={hasFilters} />
  }

  return (
    <Table>
      <TableHeader>
        <TableRow>
          <TableHead>User</TableHead>
          <TableHead>Role</TableHead>
          <TableHead>Status</TableHead>
          <TableHead>Created</TableHead>
          <TableHead className="w-12 text-right">Actions</TableHead>
        </TableRow>
      </TableHeader>
      <TableBody>
        {users.map((user) => (
          <TableRow key={user.id}>
            <TableCell className="min-w-64 max-w-96">
              <div className="flex min-w-0 items-center gap-3">
                <Avatar>
                  <AvatarFallback>{userInitials(user)}</AvatarFallback>
                </Avatar>
                <div className="min-w-0 space-y-1">
                  <p className="truncate font-medium">{user.name || 'Unnamed user'}</p>
                  <div className="flex min-w-0 flex-col gap-0.5 text-sm text-muted-foreground sm:flex-row sm:items-center sm:gap-2">
                    <span className="truncate">{user.email}</span>
                    {user.username ? <span className="truncate sm:before:mr-2 sm:before:content-['/']">@{user.username}</span> : null}
                  </div>
                </div>
              </div>
            </TableCell>
            <TableCell>
              <Badge variant="outline" className="capitalize">{user.role}</Badge>
            </TableCell>
            <TableCell>
              <Badge variant={user.status === 'active' ? 'secondary' : 'destructive'} className="capitalize">
                {user.status}
              </Badge>
            </TableCell>
            <TableCell>{user.created_at}</TableCell>
            <TableCell className="text-right">
              <DropdownMenu>
                <DropdownMenuTrigger render={<Button variant="ghost" size="icon-sm" aria-label={`Actions for ${user.email}`} />}>
                  <MoreHorizontal />
                </DropdownMenuTrigger>
                <DropdownMenuContent align="end" className="w-36">
                  <DropdownMenuGroup>
                    <DropdownMenuLabel>Actions</DropdownMenuLabel>
                  </DropdownMenuGroup>
                  <DropdownMenuItem render={<Link href={`/admin/users/${user.id}/edit`}>Edit user</Link>} />
                  <DropdownMenuSeparator />
                  <DropdownMenuItem variant="destructive" onClick={() => onDelete(user)}>
                    Delete user
                  </DropdownMenuItem>
                </DropdownMenuContent>
              </DropdownMenu>
            </TableCell>
          </TableRow>
        ))}
      </TableBody>
    </Table>
  )
}

function UsersEmptyState({ hasFilters }: { hasFilters: boolean }) {
  return (
    <Empty className="border py-12">
      <EmptyHeader>
        <EmptyMedia variant="icon">
          {hasFilters ? <SearchX /> : <Users />}
        </EmptyMedia>
        <EmptyTitle>{hasFilters ? 'No matching users' : 'No users yet'}</EmptyTitle>
        <EmptyDescription>
          {hasFilters
            ? 'Try clearing filters or searching for another email, name, or username.'
            : 'Create the first account to start managing this workspace.'}
        </EmptyDescription>
      </EmptyHeader>
    </Empty>
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

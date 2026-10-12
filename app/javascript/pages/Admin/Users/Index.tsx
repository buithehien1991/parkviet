import { Head, Link, router } from '@inertiajs/react'
import { useState } from 'react'

import { AdminPageHeader } from '@/components/admin/admin-page-header'
import { NumberedPagination } from '@/components/shared/numbered-pagination'
import { DeleteUserDialog } from '@/components/admin/users/delete-user-dialog'
import { UsersOverviewStrip } from '@/components/admin/users/users-overview-strip'
import { UsersTable } from '@/components/admin/users/users-table'
import { UsersWorkspaceToolbar } from '@/components/admin/users/users-workspace-toolbar'
import { Button } from '@/components/ui/button'
import { Card, CardContent, CardDescription, CardHeader, CardTitle } from '@/components/ui/card'
import type { AdminUser, AdminUserFilters, AdminUserSearch, AdminUsersOverview, PaginationData, SelectOption } from '@/types'

type Props = {
  users: AdminUser[]
  filters: AdminUserFilters
  overview: AdminUsersOverview
  pagination: PaginationData
  role_options: SelectOption[]
  status_options: SelectOption[]
}

export default function AdminUsersIndex({
  users,
  filters,
  overview,
  pagination,
  role_options,
  status_options,
}: Props) {
  const [search, setSearch] = useState<AdminUserSearch>(filters.q)
  const [deleteUser, setDeleteUser] = useState<AdminUser | null>(null)
  const hasFilters = Object.values(filters.q).some(Boolean)

  function applyFilters(nextSearch = search) {
    const q = compactSearch(nextSearch)

    router.get('/admin/users', Object.keys(q).length ? { q } : {}, {
      preserveState: true,
      preserveScroll: true,
    })
  }

  function clearFilters() {
    setSearch({})
    router.get('/admin/users', {}, { preserveState: true, preserveScroll: true })
  }

  return (
    <>
      <Head title="Users" />

      <AdminPageHeader
        title="Users"
        description="Search, filter, and manage account access from one operator workspace."
        actions={
          <Button nativeButton={false} render={<Link href="/admin/users/new" />}>
            Create user
          </Button>
        }
      />

      <div className="space-y-6 p-4 sm:p-6">
        <UsersOverviewStrip overview={overview} />

        <Card>
          <CardHeader>
            <CardTitle>User directory</CardTitle>
            <CardDescription>
              Filter by identity, role, and account status. Results stay in the URL for sharing and pagination.
            </CardDescription>
          </CardHeader>
          <CardContent className="space-y-4">
            <UsersWorkspaceToolbar
              search={search}
              roleOptions={role_options}
              statusOptions={status_options}
              hasFilters={hasFilters}
              onSearchChange={setSearch}
              onApply={() => applyFilters()}
              onClear={clearFilters}
            />

            <UsersTable users={users} hasFilters={hasFilters} onDelete={setDeleteUser} />

            <NumberedPagination
              pagination={pagination}
              itemLabel="users"
              buildHref={(page) => buildUsersIndexHref(page, filters.q)}
            />
          </CardContent>
        </Card>
      </div>

      <DeleteUserDialog
        open={!!deleteUser}
        onOpenChange={(open) => {
          if (!open) {
            setDeleteUser(null)
          }
        }}
        userId={deleteUser?.id ?? null}
        userLabel={deleteUser?.email ?? 'this user'}
        filters={filters.q}
      />
    </>
  )
}

function compactSearch(search: AdminUserSearch) {
  return Object.fromEntries(
    Object.entries(search).filter(([, value]) => value && value.trim() !== '')
  )
}

function buildUsersIndexHref(page: number, search: AdminUserSearch) {
  const params = new URLSearchParams()
  const compactedSearch = compactSearch(search)

  Object.entries(compactedSearch).forEach(([key, value]) => {
    params.set(`q[${key}]`, value)
  })

  if (page > 1) {
    params.set('page', page.toString())
  }

  const queryString = params.toString()

  return queryString ? `/admin/users?${queryString}` : '/admin/users'
}

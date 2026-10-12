import { Head, Link } from '@inertiajs/react'

import { AdminPageHeader } from '@/components/admin/admin-page-header'
import { UserForm } from '@/components/admin/users/user-form'
import { Button } from '@/components/ui/button'
import { Card, CardContent, CardDescription, CardHeader, CardTitle } from '@/components/ui/card'
import type { AdminUserFormValues, SelectOption } from '@/types'

type Props = {
  user: AdminUserFormValues
  role_options: SelectOption[]
  status_options: SelectOption[]
  errors?: Record<string, string>
}

export default function AdminUsersEdit({ user, role_options, status_options, errors = {} }: Props) {
  return (
    <>
      <Head title="Edit User" />

      <AdminPageHeader
        title="Edit user"
        description="Update account details without forcing a password change."
        actions={
          <Button variant="outline" nativeButton={false} render={<Link href="/admin/users" />}>
            Back to users
          </Button>
        }
      />

      <div className="p-4 sm:p-6">
        <Card className="max-w-3xl">
          <CardHeader>
            <CardTitle>User details</CardTitle>
            <CardDescription>Leave password fields empty to keep the existing password.</CardDescription>
          </CardHeader>
          <CardContent>
            <UserForm
              user={user}
              roleOptions={role_options}
              statusOptions={status_options}
              submitLabel="Save changes"
              submitPath={`/admin/users/${user.id}`}
              method="patch"
              pageErrors={errors}
            />
          </CardContent>
        </Card>
      </div>
    </>
  )
}

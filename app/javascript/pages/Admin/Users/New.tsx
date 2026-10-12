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

export default function AdminUsersNew({ user, role_options, status_options, errors = {} }: Props) {
  return (
    <>
      <Head title="Create User" />

      <AdminPageHeader
        title="Create user"
        description="Create a new user account and assign the initial role and status."
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
            <CardDescription>Password is required when creating a user.</CardDescription>
          </CardHeader>
          <CardContent>
            <UserForm
              user={user}
              roleOptions={role_options}
              statusOptions={status_options}
              submitLabel="Create user"
              submitPath="/admin/users"
              method="post"
              pageErrors={errors}
            />
          </CardContent>
        </Card>
      </div>
    </>
  )
}

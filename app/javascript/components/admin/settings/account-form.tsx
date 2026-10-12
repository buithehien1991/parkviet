import { useForm } from '@inertiajs/react'

import { Button } from '@/components/ui/button'
import { Field, FieldDescription, FieldError, FieldGroup, FieldLabel } from '@/components/ui/field'
import { Input } from '@/components/ui/input'
import { Spinner } from '@/components/ui/spinner'
import type { AdminSettingsAccountFormData, AdminSettingsUser } from '@/types'

type AccountFormProps = {
  user: AdminSettingsUser
  pageErrors?: Record<string, string>
}

function firstError(error: string | string[] | undefined) {
  return Array.isArray(error) ? error[0] : error
}

export function AccountForm({ user, pageErrors = {} }: AccountFormProps) {
  const form = useForm<AdminSettingsAccountFormData>({
    name: user.name,
    email: user.email,
  })

  function submit(event: React.FormEvent<HTMLFormElement>) {
    event.preventDefault()
    form.transform((data) => ({ user: data }))
    form.patch('/admin/settings/account', { preserveScroll: true })
  }

  return (
    <form className="space-y-5" onSubmit={submit}>
      <FieldGroup>
        <Field data-invalid={!!firstError(form.errors.name ?? pageErrors.name)}>
          <FieldLabel htmlFor="account-name">Name</FieldLabel>
          <Input
            id="account-name"
            placeholder="Your full name"
            autoComplete="name"
            value={form.data.name}
            onChange={(event) => form.setData('name', event.target.value)}
          />
          <FieldDescription>
            This is the name that will be displayed on your profile and in emails.
          </FieldDescription>
          <FieldError>{firstError(form.errors.name ?? pageErrors.name)}</FieldError>
        </Field>

        <Field data-invalid={!!firstError(form.errors.email ?? pageErrors.email)}>
          <FieldLabel htmlFor="account-email">Email</FieldLabel>
          <Input
            id="account-email"
            type="email"
            placeholder="you@example.com"
            autoComplete="email"
            value={form.data.email}
            onChange={(event) => form.setData('email', event.target.value)}
          />
          <FieldDescription>
            We use this email for account access and important notifications.
          </FieldDescription>
          <FieldError>{firstError(form.errors.email ?? pageErrors.email)}</FieldError>
        </Field>
      </FieldGroup>

      <div className="flex">
        <Button type="submit" disabled={form.processing}>
          {form.processing ? <Spinner className="mr-2" /> : null}
          Update account
        </Button>
      </div>
    </form>
  )
}

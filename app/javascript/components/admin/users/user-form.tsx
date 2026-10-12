import { useForm } from '@inertiajs/react'

import { Button } from '@/components/ui/button'
import { Field, FieldError, FieldGroup, FieldLabel } from '@/components/ui/field'
import { Input } from '@/components/ui/input'
import {
  Select,
  SelectContent,
  SelectItem,
  SelectTrigger,
  SelectValue,
} from '@/components/ui/select'
import { Spinner } from '@/components/ui/spinner'
import type { AdminUserFormValues, SelectOption } from '@/types'

type UserFormProps = {
  user: AdminUserFormValues
  roleOptions: SelectOption[]
  statusOptions: SelectOption[]
  submitLabel: string
  submitPath: string
  method: 'post' | 'patch'
  pageErrors?: Record<string, string>
}

type UserFormData = {
  email: string
  name: string
  username: string
  role_id: string
  status: string
  password: string
  password_confirmation: string
}

function firstError(error: string | string[] | undefined) {
  return Array.isArray(error) ? error[0] : error
}

export function UserForm({
  user,
  roleOptions,
  statusOptions,
  submitLabel,
  submitPath,
  method,
  pageErrors = {},
}: UserFormProps) {
  const form = useForm<UserFormData>({
    email: user.email,
    name: user.name,
    username: user.username,
    role_id: user.role_id,
    status: user.status,
    password: '',
    password_confirmation: '',
  })

  function submit(event: React.FormEvent<HTMLFormElement>) {
    event.preventDefault()
    form.transform((data) => ({ user: data }))

    if (method === 'post') {
      form.post(submitPath)
      return
    }

    form.patch(submitPath)
  }

  return (
    <form className="space-y-5" onSubmit={submit}>
      <FieldGroup>
        <Field data-invalid={!!firstError(form.errors.email ?? pageErrors.email)}>
          <FieldLabel htmlFor="email">Email</FieldLabel>
          <Input
            id="email"
            type="email"
            autoComplete="email"
            value={form.data.email}
            onChange={(event) => form.setData('email', event.target.value)}
          />
          <FieldError>{firstError(form.errors.email ?? pageErrors.email)}</FieldError>
        </Field>

        <Field data-invalid={!!firstError(form.errors.name ?? pageErrors.name)}>
          <FieldLabel htmlFor="name">Name</FieldLabel>
          <Input
            id="name"
            value={form.data.name}
            onChange={(event) => form.setData('name', event.target.value)}
          />
          <FieldError>{firstError(form.errors.name ?? pageErrors.name)}</FieldError>
        </Field>

        <Field data-invalid={!!firstError(form.errors.username ?? pageErrors.username)}>
          <FieldLabel htmlFor="username">Username</FieldLabel>
          <Input
            id="username"
            value={form.data.username}
            onChange={(event) => form.setData('username', event.target.value)}
          />
          <FieldError>{firstError(form.errors.username ?? pageErrors.username)}</FieldError>
        </Field>

        <div className="grid gap-5 md:grid-cols-2">
          <Field data-invalid={!!firstError(form.errors.role_id ?? pageErrors.role_id)}>
            <FieldLabel htmlFor="role">Role</FieldLabel>
            <Select value={form.data.role_id} onValueChange={(value) => value && form.setData('role_id', value)}>
              <SelectTrigger id="role" className="w-full">
                <SelectValue />
              </SelectTrigger>
              <SelectContent>
                {roleOptions.map((option) => (
                  <SelectItem key={option.value} value={option.value}>
                    {option.label}
                  </SelectItem>
                ))}
              </SelectContent>
            </Select>
            <FieldError>{firstError(form.errors.role_id ?? pageErrors.role_id)}</FieldError>
          </Field>

          <Field data-invalid={!!firstError(form.errors.status ?? pageErrors.status)}>
            <FieldLabel htmlFor="status">Status</FieldLabel>
            <Select value={form.data.status} onValueChange={(value) => value && form.setData('status', value)}>
              <SelectTrigger id="status" className="w-full">
                <SelectValue />
              </SelectTrigger>
              <SelectContent>
                {statusOptions.map((option) => (
                  <SelectItem key={option.value} value={option.value}>
                    {option.label}
                  </SelectItem>
                ))}
              </SelectContent>
            </Select>
            <FieldError>{firstError(form.errors.status ?? pageErrors.status)}</FieldError>
          </Field>
        </div>

        <div className="grid gap-5 md:grid-cols-2">
          <Field data-invalid={!!firstError(form.errors.password ?? pageErrors.password)}>
            <FieldLabel htmlFor="password">Password</FieldLabel>
            <Input
              id="password"
              type="password"
              autoComplete="new-password"
              value={form.data.password}
              onChange={(event) => form.setData('password', event.target.value)}
            />
            <FieldError>{firstError(form.errors.password ?? pageErrors.password)}</FieldError>
          </Field>

          <Field data-invalid={!!firstError(form.errors.password_confirmation ?? pageErrors.password_confirmation)}>
            <FieldLabel htmlFor="password_confirmation">Confirm password</FieldLabel>
            <Input
              id="password_confirmation"
              type="password"
              autoComplete="new-password"
              value={form.data.password_confirmation}
              onChange={(event) => form.setData('password_confirmation', event.target.value)}
            />
            <FieldError>{firstError(form.errors.password_confirmation ?? pageErrors.password_confirmation)}</FieldError>
          </Field>
        </div>
      </FieldGroup>

      <div className="flex justify-end">
        <Button type="submit" disabled={form.processing}>
          {form.processing ? <Spinner className="mr-2" /> : null}
          {submitLabel}
        </Button>
      </div>
    </form>
  )
}

import { useForm } from '@inertiajs/react'

import { Avatar, AvatarFallback, AvatarImage } from '@/components/ui/avatar'
import { Button } from '@/components/ui/button'
import { Field, FieldDescription, FieldError, FieldGroup, FieldLabel } from '@/components/ui/field'
import { Input } from '@/components/ui/input'
import { Spinner } from '@/components/ui/spinner'
import type { AdminSettingsProfileFormData, AdminSettingsUser } from '@/types'

type ProfileFormProps = {
  user: AdminSettingsUser
  pageErrors?: Record<string, string>
}

function firstError(error: string | string[] | undefined) {
  return Array.isArray(error) ? error[0] : error
}

export function ProfileForm({ user, pageErrors = {} }: ProfileFormProps) {
  const form = useForm<AdminSettingsProfileFormData>({
    name: user.name,
    username: user.username,
    avatar: null,
  })

  const initials = (user.name || user.username || user.email || 'U')
    .split(/\s+/)
    .filter(Boolean)
    .slice(0, 2)
    .map((part) => part[0]?.toUpperCase())
    .join('')

  function submit(event: React.FormEvent<HTMLFormElement>) {
    event.preventDefault()
    form.transform((data) => {
      const user: Record<string, string | File> = {
        name: data.name,
        username: data.username,
      }

      if (data.avatar) {
        user.avatar = data.avatar
      }

      return { user }
    })
    form.patch('/admin/settings/profile', { preserveScroll: true, forceFormData: true })
  }

  return (
    <form className="space-y-5" onSubmit={submit}>
      <FieldGroup>
        <Field data-invalid={!!firstError(form.errors.avatar ?? pageErrors.avatar)}>
          <FieldLabel htmlFor="profile-avatar">Avatar</FieldLabel>
          <div className="flex items-center gap-4">
            <Avatar size="lg">
              {user.avatar_url ? <AvatarImage src={user.avatar_url} alt={user.name || user.username || user.email} /> : null}
              <AvatarFallback>{initials || 'U'}</AvatarFallback>
            </Avatar>
            <Input
              id="profile-avatar"
              type="file"
              accept="image/png,image/jpeg,image/gif,image/webp"
              onChange={(event) => form.setData('avatar', event.target.files?.[0] ?? null)}
            />
          </div>
          <FieldDescription>
            Upload a JPG, PNG, GIF, or WebP image up to 5 MB.
          </FieldDescription>
          <FieldError>{firstError(form.errors.avatar ?? pageErrors.avatar)}</FieldError>
        </Field>

        <Field data-invalid={!!firstError(form.errors.username ?? pageErrors.username)}>
          <FieldLabel htmlFor="profile-username">Username</FieldLabel>
          <Input
            id="profile-username"
            placeholder="your-handle"
            autoComplete="username"
            value={form.data.username}
            onChange={(event) => form.setData('username', event.target.value)}
          />
          <FieldDescription>
            This is your public display handle. It can only contain letters, numbers, and underscores.
          </FieldDescription>
          <FieldError>{firstError(form.errors.username ?? pageErrors.username)}</FieldError>
        </Field>

        <Field data-invalid={!!firstError(form.errors.name ?? pageErrors.name)}>
          <FieldLabel htmlFor="profile-name">Name</FieldLabel>
          <Input
            id="profile-name"
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
      </FieldGroup>

      <div className="flex">
        <Button type="submit" disabled={form.processing}>
          {form.processing ? <Spinner className="mr-2" /> : null}
          Update profile
        </Button>
      </div>
    </form>
  )
}

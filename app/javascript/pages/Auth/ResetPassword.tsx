import { Head, Link, useForm } from '@inertiajs/react'

import { Button } from '@/components/ui/button'
import {
  Card,
  CardContent,
  CardDescription,
  CardHeader,
  CardTitle,
} from '@/components/ui/card'
import { Field, FieldDescription, FieldError, FieldGroup, FieldLabel } from '@/components/ui/field'
import { Input } from '@/components/ui/input'
import { Spinner } from '@/components/ui/spinner'

type ResetPasswordPageProps = {
  reset_password_token: string | null
  minimum_password_length: number | null
  can_sign_in: boolean
}

type ResetPasswordFormData = {
  reset_password_token: string
  password: string
  password_confirmation: string
}

type InertiaPageProps = {
  errors: Record<string, string>
} & ResetPasswordPageProps

function firstError(error: string | string[] | undefined) {
  return Array.isArray(error) ? error[0] : error
}

export default function ResetPassword({
  errors: pageErrors = {},
  reset_password_token,
  minimum_password_length,
  can_sign_in,
}: InertiaPageProps) {
  const form = useForm<ResetPasswordFormData>({
    reset_password_token: reset_password_token ?? '',
    password: '',
    password_confirmation: '',
  })

  function submit(event: React.FormEvent<HTMLFormElement>) {
    event.preventDefault()

    form.transform((data) => ({ user: data }))
    form.put('/users/password')
  }

  const tokenError = firstError(pageErrors.reset_password_token)
  const passwordError = firstError(form.errors.password ?? pageErrors.password)
  const passwordConfirmationError = firstError(form.errors.password_confirmation ?? pageErrors.password_confirmation)
  const errorMessages = [tokenError, passwordError, passwordConfirmationError].filter(Boolean)

  return (
    <>
      <Head title="Reset password" />

      <main className="flex min-h-screen items-center justify-center bg-muted/30 px-4 py-10">
        <Card className="w-full max-w-md">
          <CardHeader className="space-y-1">
            <CardTitle>Change your password</CardTitle>
            <CardDescription>
              Set a new password for your account to complete the reset process.
            </CardDescription>
          </CardHeader>

          <CardContent>
            <form className="space-y-5" onSubmit={submit}>
              {errorMessages.length > 0 ? (
                <div className="rounded-lg border border-destructive/30 bg-destructive/10 px-3 py-2 text-sm text-destructive">
                  <p className="font-medium">Please fix the following errors:</p>
                  <ul className="mt-1 list-disc space-y-1 pl-4">
                    {errorMessages.map((message) => (
                      <li key={message}>{message}</li>
                    ))}
                  </ul>
                </div>
              ) : null}

              <FieldGroup>
                <Field data-invalid={!!passwordError}>
                  <FieldLabel htmlFor="password">New password</FieldLabel>
                  <Input
                    id="password"
                    type="password"
                    autoComplete="new-password"
                    autoFocus
                    value={form.data.password}
                    onChange={(event) => form.setData('password', event.target.value)}
                    aria-invalid={!!passwordError}
                    aria-describedby={passwordError ? 'password-error' : 'password-description'}
                  />
                  <FieldDescription id="password-description">
                    {minimum_password_length ? `Use at least ${minimum_password_length} characters.` : 'Choose a strong password.'}
                  </FieldDescription>
                  {passwordError ? <FieldError id="password-error">{passwordError}</FieldError> : null}
                </Field>

                <Field data-invalid={!!passwordConfirmationError}>
                  <FieldLabel htmlFor="password_confirmation">Confirm new password</FieldLabel>
                  <Input
                    id="password_confirmation"
                    type="password"
                    autoComplete="new-password"
                    value={form.data.password_confirmation}
                    onChange={(event) => form.setData('password_confirmation', event.target.value)}
                    aria-invalid={!!passwordConfirmationError}
                    aria-describedby={passwordConfirmationError ? 'password-confirmation-error' : undefined}
                  />
                  {passwordConfirmationError ? (
                    <FieldError id="password-confirmation-error">{passwordConfirmationError}</FieldError>
                  ) : null}
                </Field>
              </FieldGroup>

              <Button type="submit" disabled={form.processing} className="w-full">
                {form.processing ? <Spinner className="mr-2" /> : null}
                Change my password
              </Button>
            </form>

            {can_sign_in ? (
              <p className="mt-6 text-center text-sm text-muted-foreground">
                <Link href="/users/sign_in" className="font-medium text-primary underline-offset-4 hover:underline">
                  Back to log in
                </Link>
              </p>
            ) : null}
          </CardContent>
        </Card>
      </main>
    </>
  )
}

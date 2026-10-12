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

type ForgotPasswordPageProps = {
  email: string | null
  can_register: boolean
  can_sign_in: boolean
}

type ForgotPasswordFormData = {
  email: string
}

type InertiaPageProps = {
  errors: Record<string, string>
} & ForgotPasswordPageProps

function firstError(error: string | string[] | undefined) {
  return Array.isArray(error) ? error[0] : error
}

export default function ForgotPassword({
  errors: pageErrors = {},
  email,
  can_register,
  can_sign_in,
}: InertiaPageProps) {
  const form = useForm<ForgotPasswordFormData>({
    email: email ?? '',
  })

  function submit(event: React.FormEvent<HTMLFormElement>) {
    event.preventDefault()

    form.transform((data) => ({ user: data }))
    form.post('/users/password')
  }

  const emailError = firstError(form.errors.email ?? pageErrors.email)
  const errorMessages = [emailError].filter(Boolean)

  return (
    <>
      <Head title="Forgot password" />

      <main className="flex min-h-screen items-center justify-center bg-muted/30 px-4 py-10">
        <Card className="w-full max-w-md">
          <CardHeader className="space-y-1">
            <CardTitle>Forgot your password?</CardTitle>
            <CardDescription>
              Enter your email and we will send you instructions to reset your password.
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
                <Field data-invalid={!!emailError}>
                  <FieldLabel htmlFor="email">Email</FieldLabel>
                  <Input
                    id="email"
                    type="email"
                    autoComplete="email"
                    autoFocus
                    value={form.data.email}
                    onChange={(event) => form.setData('email', event.target.value)}
                    aria-invalid={!!emailError}
                    aria-describedby={emailError ? 'email-error' : 'email-description'}
                  />
                  <FieldDescription id="email-description">
                    Use the email address associated with your account.
                  </FieldDescription>
                  {emailError ? <FieldError id="email-error">{emailError}</FieldError> : null}
                </Field>
              </FieldGroup>

              <Button type="submit" disabled={form.processing} className="w-full">
                {form.processing ? <Spinner className="mr-2" /> : null}
                Send reset instructions
              </Button>
            </form>

            <div className="mt-6 space-y-2 text-center text-sm text-muted-foreground">
              {can_sign_in ? (
                <p>
                  <Link href="/users/sign_in" className="font-medium text-primary underline-offset-4 hover:underline">
                    Back to log in
                  </Link>
                </p>
              ) : null}

              {can_register ? (
                <p>
                  Need an account?{' '}
                  <Link href="/users/sign_up" className="font-medium text-primary underline-offset-4 hover:underline">
                    Sign up
                  </Link>
                </p>
              ) : null}
            </div>
          </CardContent>
        </Card>
      </main>
    </>
  )
}

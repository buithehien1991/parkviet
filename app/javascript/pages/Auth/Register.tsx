import { Head, Link, useForm } from '@inertiajs/react'

import { Button, buttonVariants } from '@/components/ui/button'
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

type RegisterPageProps = {
  email: string | null
  minimum_password_length: number | null
  csrf_token: string
  google_oauth_enabled: boolean
}

type RegisterFormData = {
  email: string
  password: string
  password_confirmation: string
}

type InertiaPageProps = {
  errors: Record<string, string>
} & RegisterPageProps

function firstError(error: string | string[] | undefined) {
  return Array.isArray(error) ? error[0] : error
}

export default function Register({
  errors: pageErrors = {},
  email,
  minimum_password_length,
  csrf_token,
  google_oauth_enabled,
}: InertiaPageProps) {
  const form = useForm<RegisterFormData>({
    email: email ?? '',
    password: '',
    password_confirmation: '',
  })

  function submit(event: React.FormEvent<HTMLFormElement>) {
    event.preventDefault()

    form.transform((data) => ({ user: data }))
    form.post('/users')
  }

  const emailError = firstError(form.errors.email ?? pageErrors.email)
  const passwordError = firstError(form.errors.password ?? pageErrors.password)
  const passwordConfirmationError = firstError(form.errors.password_confirmation ?? pageErrors.password_confirmation)
  const errorMessages = [emailError, passwordError, passwordConfirmationError].filter(Boolean)

  return (
    <>
      <Head title="Sign up" />

      <main className="flex min-h-screen items-center justify-center bg-muted/30 px-4 py-10">
        <Card className="w-full max-w-md">
          <CardHeader className="space-y-1">
            <CardTitle>Create your account</CardTitle>
            <CardDescription>
              Sign up with your email and password to start using the app.
            </CardDescription>
          </CardHeader>

          <CardContent>
            {google_oauth_enabled ? (
              <div className="mb-5 space-y-3">
                <form action="/users/auth/google_oauth2" method="post">
                  <input type="hidden" name="authenticity_token" value={csrf_token} />
                  <button type="submit" className={`${buttonVariants({ variant: 'outline' })} h-9 w-full`}>
                    Continue with Google
                  </button>
                </form>
                <p className="text-center text-xs text-muted-foreground">Or create an account with email</p>
              </div>
            ) : null}

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
                    aria-describedby={emailError ? 'email-error' : undefined}
                  />
                  {emailError ? <FieldError id="email-error">{emailError}</FieldError> : null}
                </Field>

                <Field data-invalid={!!passwordError}>
                  <FieldLabel htmlFor="password">Password</FieldLabel>
                  <Input
                    id="password"
                    type="password"
                    autoComplete="new-password"
                    value={form.data.password}
                    onChange={(event) => form.setData('password', event.target.value)}
                    aria-invalid={!!passwordError}
                    aria-describedby={passwordError ? 'password-error' : undefined}
                  />
                  {minimum_password_length ? (
                    <FieldDescription>
                      Use at least {minimum_password_length} characters.
                    </FieldDescription>
                  ) : null}
                  {passwordError ? <FieldError id="password-error">{passwordError}</FieldError> : null}
                </Field>

                <Field data-invalid={!!passwordConfirmationError}>
                  <FieldLabel htmlFor="password_confirmation">Confirm password</FieldLabel>
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
                Create account
              </Button>
            </form>

            <p className="mt-6 text-center text-sm text-muted-foreground">
              Already have an account?{' '}
              <Link href="/users/sign_in" className="font-medium text-primary underline-offset-4 hover:underline">
                Sign in
              </Link>
            </p>
          </CardContent>
        </Card>
      </main>
    </>
  )
}

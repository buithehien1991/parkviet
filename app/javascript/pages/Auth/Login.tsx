import { Head, Link, useForm } from '@inertiajs/react'

import { Button, buttonVariants } from '@/components/ui/button'
import {
  Card,
  CardContent,
  CardDescription,
  CardHeader,
  CardTitle,
} from '@/components/ui/card'
import { Checkbox } from '@/components/ui/checkbox'
import { Field, FieldDescription, FieldError, FieldGroup, FieldLabel } from '@/components/ui/field'
import { Input } from '@/components/ui/input'
import { Spinner } from '@/components/ui/spinner'

type LoginPageProps = {
  email: string | null
  remember_me: boolean
  rememberable: boolean
  can_register: boolean
  can_recover_password: boolean
  csrf_token: string
  google_oauth_enabled: boolean
}

type LoginFormData = {
  email: string
  password: string
  remember_me: boolean
}

type InertiaPageProps = {
  errors: Record<string, string>
} & LoginPageProps

function firstError(error: string | string[] | undefined) {
  return Array.isArray(error) ? error[0] : error
}

export default function Login({
  errors: pageErrors = {},
  email,
  remember_me,
  rememberable,
  can_register,
  can_recover_password,
  csrf_token,
  google_oauth_enabled,
}: InertiaPageProps) {
  const form = useForm<LoginFormData>({
    email: email ?? '',
    password: '',
    remember_me,
  })

  function submit(event: React.FormEvent<HTMLFormElement>) {
    event.preventDefault()

    form.transform((data) => ({ user: data }))
    form.post('/users/sign_in')
  }

  const emailError = firstError(form.errors.email ?? pageErrors.email)
  const passwordError = firstError(form.errors.password ?? pageErrors.password)
  const baseError = firstError(pageErrors.base)
  const errorMessages = [baseError, emailError, passwordError].filter(Boolean)

  return (
    <>
      <Head title="Log in" />

      <main className="flex min-h-screen items-center justify-center bg-muted/30 px-4 py-10">
        <Card className="w-full max-w-md">
          <CardHeader className="space-y-1">
            <CardTitle>Welcome back</CardTitle>
            <CardDescription>
              Log in with your email and password to continue.
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
                <p className="text-center text-xs text-muted-foreground">Or continue with email</p>
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
                    autoComplete="current-password"
                    value={form.data.password}
                    onChange={(event) => form.setData('password', event.target.value)}
                    aria-invalid={!!passwordError}
                    aria-describedby={passwordError ? 'password-error' : undefined}
                  />
                  {passwordError ? <FieldError id="password-error">{passwordError}</FieldError> : null}
                </Field>

                {rememberable ? (
                  <Field orientation="horizontal">
                    <Checkbox
                      id="remember_me"
                      checked={form.data.remember_me}
                      onCheckedChange={(checked) => form.setData('remember_me', checked === true)}
                    />
                    <FieldLabel htmlFor="remember_me">Remember me</FieldLabel>
                  </Field>
                ) : null}
              </FieldGroup>

              <Button type="submit" disabled={form.processing} className="w-full">
                {form.processing ? <Spinner className="mr-2" /> : null}
                Log in
              </Button>
            </form>

            <div className="mt-6 space-y-2 text-center text-sm text-muted-foreground">
              {can_register ? (
                <p>
                  Need an account?{' '}
                  <Link href="/users/sign_up" className="font-medium text-primary underline-offset-4 hover:underline">
                    Sign up
                  </Link>
                </p>
              ) : null}

              {can_recover_password ? (
                <p>
                  <Link
                    href="/users/password/new"
                    className="font-medium text-primary underline-offset-4 hover:underline"
                  >
                    Forgot your password?
                  </Link>
                </p>
              ) : null}

              <FieldDescription>
                Use the same email you registered with.
              </FieldDescription>
            </div>
          </CardContent>
        </Card>
      </main>
    </>
  )
}

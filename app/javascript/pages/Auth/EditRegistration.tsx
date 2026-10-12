import { Head, Link, useForm } from '@inertiajs/react'

import {
  AlertDialog,
  AlertDialogAction,
  AlertDialogCancel,
  AlertDialogContent,
  AlertDialogDescription,
  AlertDialogFooter,
  AlertDialogHeader,
  AlertDialogTitle,
  AlertDialogTrigger,
} from '@/components/ui/alert-dialog'
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

type EditRegistrationPageProps = {
  email: string | null
  minimum_password_length: number | null
  pending_reconfirmation: boolean
  unconfirmed_email: string | null
}

type EditRegistrationFormData = {
  email: string
  password: string
  password_confirmation: string
  current_password: string
}

type InertiaPageProps = {
  errors: Record<string, string>
} & EditRegistrationPageProps

function firstError(error: string | string[] | undefined) {
  return Array.isArray(error) ? error[0] : error
}

export default function EditRegistration({
  errors: pageErrors = {},
  email,
  minimum_password_length,
  pending_reconfirmation,
  unconfirmed_email,
}: InertiaPageProps) {
  const form = useForm<EditRegistrationFormData>({
    email: email ?? '',
    password: '',
    password_confirmation: '',
    current_password: '',
  })

  const destroyForm = useForm({})

  function submit(event: React.FormEvent<HTMLFormElement>) {
    event.preventDefault()

    form.transform((data) => ({ user: data }))
    form.put('/users')
  }

  function destroyAccount() {
    destroyForm.delete('/users')
  }

  const emailError = firstError(form.errors.email ?? pageErrors.email)
  const passwordError = firstError(form.errors.password ?? pageErrors.password)
  const passwordConfirmationError = firstError(form.errors.password_confirmation ?? pageErrors.password_confirmation)
  const currentPasswordError = firstError(form.errors.current_password ?? pageErrors.current_password)
  const errorMessages = [emailError, passwordError, passwordConfirmationError, currentPasswordError].filter(Boolean)

  return (
    <>
      <Head title="Edit account" />

      <main className="flex min-h-screen items-center justify-center bg-muted/30 px-4 py-10">
        <div className="flex w-full max-w-md flex-col gap-6">
          <Card>
            <CardHeader className="space-y-1">
              <CardTitle>Update your account</CardTitle>
              <CardDescription>
                Change your email or password. Enter your current password to save changes.
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
                      aria-describedby={emailError ? 'email-error' : undefined}
                    />
                    {pending_reconfirmation && unconfirmed_email ? (
                      <FieldDescription>
                        Currently waiting confirmation for: {unconfirmed_email}
                      </FieldDescription>
                    ) : null}
                    {emailError ? <FieldError id="email-error">{emailError}</FieldError> : null}
                  </Field>

                  <Field data-invalid={!!passwordError}>
                    <FieldLabel htmlFor="password">New password</FieldLabel>
                    <Input
                      id="password"
                      type="password"
                      autoComplete="new-password"
                      value={form.data.password}
                      onChange={(event) => form.setData('password', event.target.value)}
                      aria-invalid={!!passwordError}
                      aria-describedby={passwordError ? 'password-error' : 'password-description'}
                    />
                    <FieldDescription id="password-description">
                      Leave blank if you do not want to change it.
                      {minimum_password_length ? ` Use at least ${minimum_password_length} characters.` : ''}
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

                  <Field data-invalid={!!currentPasswordError}>
                    <FieldLabel htmlFor="current_password">Current password</FieldLabel>
                    <Input
                      id="current_password"
                      type="password"
                      autoComplete="current-password"
                      value={form.data.current_password}
                      onChange={(event) => form.setData('current_password', event.target.value)}
                      aria-invalid={!!currentPasswordError}
                      aria-describedby={currentPasswordError ? 'current-password-error' : 'current-password-description'}
                    />
                    <FieldDescription id="current-password-description">
                      We need your current password to confirm your changes.
                    </FieldDescription>
                    {currentPasswordError ? <FieldError id="current-password-error">{currentPasswordError}</FieldError> : null}
                  </Field>
                </FieldGroup>

                <Button type="submit" disabled={form.processing} className="w-full">
                  {form.processing ? <Spinner className="mr-2" /> : null}
                  Update account
                </Button>
              </form>
            </CardContent>
          </Card>

          <Card className="border-destructive/30">
            <CardHeader className="space-y-1">
              <CardTitle>Cancel account</CardTitle>
              <CardDescription>
                Permanently delete your account and remove access to this app.
              </CardDescription>
            </CardHeader>

            <CardContent className="flex flex-col gap-4 sm:flex-row sm:items-center sm:justify-between">
              <p className="text-sm text-muted-foreground">This action cannot be undone.</p>

              <AlertDialog>
                <AlertDialogTrigger render={<Button variant="destructive" disabled={destroyForm.processing} />}>
                  {destroyForm.processing ? <Spinner className="mr-2" /> : null}
                  Cancel my account
                </AlertDialogTrigger>
                <AlertDialogContent>
                  <AlertDialogHeader>
                    <AlertDialogTitle>Cancel your account?</AlertDialogTitle>
                    <AlertDialogDescription>
                      This will permanently delete your account. This action cannot be undone.
                    </AlertDialogDescription>
                  </AlertDialogHeader>
                  <AlertDialogFooter>
                    <AlertDialogCancel disabled={destroyForm.processing}>Keep account</AlertDialogCancel>
                    <AlertDialogAction
                      variant="destructive"
                      disabled={destroyForm.processing}
                      onClick={destroyAccount}
                    >
                      {destroyForm.processing ? <Spinner className="mr-2" /> : null}
                      Delete account
                    </AlertDialogAction>
                  </AlertDialogFooter>
                </AlertDialogContent>
              </AlertDialog>
            </CardContent>
          </Card>

          <p className="text-center text-sm text-muted-foreground">
            <Link href="/" className="font-medium text-primary underline-offset-4 hover:underline">
              Back to home
            </Link>
          </p>
        </div>
      </main>
    </>
  )
}

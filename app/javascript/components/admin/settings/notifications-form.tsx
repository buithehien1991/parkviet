import { useForm } from '@inertiajs/react'

import { Button } from '@/components/ui/button'
import { Field, FieldError, FieldGroup, FieldLabel } from '@/components/ui/field'
import { RadioGroup, RadioGroupItem } from '@/components/ui/radio-group'
import { Spinner } from '@/components/ui/spinner'
import { Switch } from '@/components/ui/switch'
import { cn } from '@/lib/utils'
import type {
  AdminNotificationType,
  AdminSettingsNotificationsFormData,
  AdminSettingsValues,
} from '@/types'

type NotificationsFormProps = {
  settings: AdminSettingsValues
  pageErrors?: Record<string, string>
}

const NOTIFY_OPTIONS: Array<{ value: AdminNotificationType; label: string; description: string }> = [
  { value: 'all', label: 'All new messages', description: 'Receive every notification across the workspace.' },
  { value: 'mentions', label: 'Direct messages and mentions', description: 'Only notify me when I am directly involved.' },
  { value: 'none', label: 'Nothing', description: 'Mute notifications entirely.' },
]

type EmailToggleKey =
  | 'notify_communication_emails'
  | 'notify_marketing_emails'
  | 'notify_social_emails'
  | 'notify_security_emails'

const EMAIL_TOGGLES: Array<{
  key: EmailToggleKey
  label: string
  description: string
  disabled?: boolean
}> = [
  {
    key: 'notify_communication_emails',
    label: 'Communication emails',
    description: 'Receive emails about your account activity.',
  },
  {
    key: 'notify_marketing_emails',
    label: 'Marketing emails',
    description: 'Receive emails about new products, features, and more.',
  },
  {
    key: 'notify_social_emails',
    label: 'Social emails',
    description: 'Receive emails for friend requests, follows, and more.',
  },
  {
    key: 'notify_security_emails',
    label: 'Security emails',
    description: 'Receive emails about your account activity and security.',
    disabled: true,
  },
]

function firstError(error: string | string[] | undefined) {
  return Array.isArray(error) ? error[0] : error
}

function asBoolean(value: boolean | null | undefined, fallback = false) {
  return typeof value === 'boolean' ? value : fallback
}

function resolveNotificationType(settings: AdminSettingsValues): AdminNotificationType {
  const value = settings.notification_type
  if (value === 'all' || value === 'mentions' || value === 'none') {
    return value
  }
  return 'all'
}

export function NotificationsForm({ settings, pageErrors = {} }: NotificationsFormProps) {
  const form = useForm<AdminSettingsNotificationsFormData>({
    notification_type: resolveNotificationType(settings),
    notify_communication_emails: asBoolean(settings.notify_communication_emails, true),
    notify_marketing_emails: asBoolean(settings.notify_marketing_emails, false),
    notify_social_emails: asBoolean(settings.notify_social_emails, true),
    notify_security_emails: true,
    notify_mobile_push: asBoolean(settings.notify_mobile_push, false),
  })

  function submit(event: React.FormEvent<HTMLFormElement>) {
    event.preventDefault()
    form.transform((data) => ({ user: data }))
    form.patch('/admin/settings/notifications', { preserveScroll: true })
  }

  return (
    <form className="space-y-8" onSubmit={submit}>
      <FieldGroup>
        <Field data-invalid={!!firstError(form.errors.notification_type ?? pageErrors.notification_type)}>
          <FieldLabel>Notify me about...</FieldLabel>
          <RadioGroup
            value={form.data.notification_type}
            onValueChange={(value) => form.setData('notification_type', value as AdminNotificationType)}
            className="grid gap-3 pt-1"
          >
            {NOTIFY_OPTIONS.map((option) => (
              <label
                key={option.value}
                htmlFor={`notify-${option.value}`}
                className="flex cursor-pointer items-start gap-3 rounded-lg border p-3 transition-colors hover:bg-muted/50"
              >
                <RadioGroupItem id={`notify-${option.value}`} value={option.value} className="mt-1" />
                <div className="flex flex-col">
                  <span className="text-sm font-medium">{option.label}</span>
                  <span className="text-xs text-muted-foreground">{option.description}</span>
                </div>
              </label>
            ))}
          </RadioGroup>
          <FieldError>
            {firstError(form.errors.notification_type ?? pageErrors.notification_type)}
          </FieldError>
        </Field>
      </FieldGroup>

      <div className="space-y-3">
        <div>
          <h4 className="text-sm font-medium">Email Notifications</h4>
          <p className="text-xs text-muted-foreground">
            Choose which email notifications you would like to receive.
          </p>
        </div>

        <div className="space-y-3">
          {EMAIL_TOGGLES.map((toggle) => (
            <div
              key={toggle.key}
              className={cn(
                'flex flex-row items-center justify-between gap-4 rounded-lg border p-4',
                toggle.disabled && 'opacity-80'
              )}
            >
              <div className="space-y-0.5">
                <p className="text-sm font-medium">{toggle.label}</p>
                <p className="text-xs text-muted-foreground">{toggle.description}</p>
              </div>
              <Switch
                checked={form.data[toggle.key]}
                onCheckedChange={(checked) => form.setData(toggle.key, checked)}
                disabled={toggle.disabled}
                aria-label={toggle.label}
              />
            </div>
          ))}
        </div>
      </div>

      <div className="flex flex-row items-center justify-between gap-4 rounded-lg border p-4">
        <div className="space-y-0.5">
          <p className="text-sm font-medium">Use different settings for my mobile devices</p>
          <p className="text-xs text-muted-foreground">
            You can manage your mobile notifications from your device settings.
          </p>
        </div>
        <Switch
          checked={form.data.notify_mobile_push}
          onCheckedChange={(checked) => form.setData('notify_mobile_push', checked)}
          aria-label="Use different settings for my mobile devices"
        />
      </div>

      <div className="flex">
        <Button type="submit" disabled={form.processing}>
          {form.processing ? <Spinner className="mr-2" /> : null}
          Update notifications
        </Button>
      </div>
    </form>
  )
}

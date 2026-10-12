import { useForm } from '@inertiajs/react'
import { useTheme } from 'next-themes'

import { Button } from '@/components/ui/button'
import { Field, FieldDescription, FieldError, FieldGroup, FieldLabel } from '@/components/ui/field'
import { RadioGroup, RadioGroupItem } from '@/components/ui/radio-group'
import { Spinner } from '@/components/ui/spinner'
import { cn } from '@/lib/utils'
import type { AdminSettingsAppearanceFormData, AdminSettingsTheme, AdminSettingsValues } from '@/types'

type AppearanceFormProps = {
  settings: AdminSettingsValues
  pageErrors?: Record<string, string>
}

const THEME_OPTIONS: Array<{ value: AdminSettingsTheme; label: string; description: string }> = [
  { value: 'light', label: 'Light', description: 'Use the light theme.' },
  { value: 'dark', label: 'Dark', description: 'Use the dark theme.' },
  { value: 'system', label: 'System', description: 'Follow your device preference.' },
]

function firstError(error: string | string[] | undefined) {
  return Array.isArray(error) ? error[0] : error
}

function resolveInitialTheme(settings: AdminSettingsValues): AdminSettingsTheme {
  return (settings.theme as AdminSettingsTheme) || 'system'
}

export function AppearanceForm({ settings, pageErrors = {} }: AppearanceFormProps) {
  const { setTheme } = useTheme()
  const form = useForm<AdminSettingsAppearanceFormData>({
    theme: resolveInitialTheme(settings),
  })

  function submit(event: React.FormEvent<HTMLFormElement>) {
    event.preventDefault()
    form.transform((data) => ({ user: data }))
    form.patch('/admin/settings/appearance', { preserveScroll: true })
  }

  return (
    <form className="space-y-6" onSubmit={submit}>
      <FieldGroup>
        <Field data-invalid={!!firstError(form.errors.theme ?? pageErrors.theme)}>
          <FieldLabel>Theme</FieldLabel>
          <FieldDescription>Select the theme for the dashboard.</FieldDescription>
          <RadioGroup
            value={form.data.theme}
            onValueChange={(value) => {
              const theme = value as AdminSettingsTheme
              form.setData('theme', theme)
              setTheme(theme)
            }}
            className="grid gap-4 pt-2 sm:grid-cols-3"
          >
            {THEME_OPTIONS.map((option) => {
              const isActive = form.data.theme === option.value
              return (
                <label
                  key={option.value}
                  htmlFor={`appearance-theme-${option.value}`}
                  className={cn(
                    'flex cursor-pointer flex-col gap-3 rounded-lg border p-3 transition-colors',
                    isActive ? 'border-primary bg-primary/5' : 'hover:bg-muted/50'
                  )}
                >
                  <ThemePreview value={option.value} />
                  <div className="flex items-center gap-2">
                    <RadioGroupItem id={`appearance-theme-${option.value}`} value={option.value} />
                    <div className="flex flex-col">
                      <span className="text-sm font-medium">{option.label}</span>
                      <span className="text-xs text-muted-foreground">{option.description}</span>
                    </div>
                  </div>
                </label>
              )
            })}
          </RadioGroup>
          <FieldError>{firstError(form.errors.theme ?? pageErrors.theme)}</FieldError>
        </Field>
      </FieldGroup>

      <div className="flex">
        <Button type="submit" disabled={form.processing}>
          {form.processing ? <Spinner className="mr-2" /> : null}
          Update preferences
        </Button>
      </div>
    </form>
  )
}

function ThemePreview({ value }: { value: AdminSettingsTheme }) {
  const palette = previewPalette(value)
  return (
    <div className={cn('rounded-md border-2 p-1', palette.outerBorder)}>
      <div className={cn('space-y-2 rounded-sm p-2', palette.innerBg)}>
        <div className={cn('space-y-2 rounded-md p-2 shadow-sm', palette.cardBg)}>
          <div className={cn('h-2 w-3/5 rounded-lg', palette.bar)} />
          <div className={cn('h-2 w-4/5 rounded-lg', palette.bar)} />
        </div>
        <div className={cn('flex items-center space-x-2 rounded-md p-2 shadow-sm', palette.cardBg)}>
          <div className={cn('h-4 w-4 rounded-full', palette.dot)} />
          <div className={cn('h-2 w-3/5 rounded-lg', palette.bar)} />
        </div>
        <div className={cn('flex items-center space-x-2 rounded-md p-2 shadow-sm', palette.cardBg)}>
          <div className={cn('h-4 w-4 rounded-full', palette.dot)} />
          <div className={cn('h-2 w-3/5 rounded-lg', palette.bar)} />
        </div>
      </div>
    </div>
  )
}

function previewPalette(value: AdminSettingsTheme) {
  if (value === 'dark') {
    return {
      outerBorder: 'border-muted bg-popover',
      innerBg: 'bg-slate-950',
      cardBg: 'bg-slate-800',
      bar: 'bg-slate-400',
      dot: 'bg-slate-400',
    }
  }
  if (value === 'light') {
    return {
      outerBorder: 'border-muted bg-popover',
      innerBg: 'bg-[#ecedef]',
      cardBg: 'bg-white',
      bar: 'bg-[#ecedef]',
      dot: 'bg-[#ecedef]',
    }
  }
  return {
    outerBorder: 'border-muted bg-popover',
    innerBg: 'bg-gradient-to-br from-[#ecedef] to-slate-900',
    cardBg: 'bg-white/80 dark:bg-slate-800/80',
    bar: 'bg-slate-300',
    dot: 'bg-slate-300',
  }
}

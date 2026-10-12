import { Head } from '@inertiajs/react'

import { AppearanceForm } from '@/components/admin/settings/appearance-form'
import { ContentSection } from '@/components/admin/settings/content-section'
import { SettingsLayout } from '@/components/admin/settings/settings-layout'
import type { AdminSettingsUser, AdminSettingsValues } from '@/types'

type Props = {
  user: AdminSettingsUser
  settings: AdminSettingsValues
  errors?: Record<string, string>
}

export default function AdminSettingsAppearance({ settings, errors }: Props) {
  return (
    <>
      <Head title="Appearance settings" />

      <SettingsLayout>
        <ContentSection
          title="Appearance"
          description="Customize the look and feel of your workspace."
        >
          <AppearanceForm settings={settings} pageErrors={errors} />
        </ContentSection>
      </SettingsLayout>
    </>
  )
}

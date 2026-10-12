import { Head } from '@inertiajs/react'

import { ContentSection } from '@/components/admin/settings/content-section'
import { NotificationsForm } from '@/components/admin/settings/notifications-form'
import { SettingsLayout } from '@/components/admin/settings/settings-layout'
import type { AdminSettingsUser, AdminSettingsValues } from '@/types'

type Props = {
  user: AdminSettingsUser
  settings: AdminSettingsValues
  errors?: Record<string, string>
}

export default function AdminSettingsNotifications({ settings, errors }: Props) {
  return (
    <>
      <Head title="Notification settings" />

      <SettingsLayout>
        <ContentSection
          title="Notifications"
          description="Configure how you receive workspace updates and alerts."
        >
          <NotificationsForm settings={settings} pageErrors={errors} />
        </ContentSection>
      </SettingsLayout>
    </>
  )
}

import { Head } from '@inertiajs/react'

import { ContentSection } from '@/components/admin/settings/content-section'
import { ProfileForm } from '@/components/admin/settings/profile-form'
import { SettingsLayout } from '@/components/admin/settings/settings-layout'
import type { AdminSettingsUser } from '@/types'

type Props = {
  user: AdminSettingsUser
  settings: Record<string, unknown>
  errors?: Record<string, string>
}

export default function AdminSettingsProfile({ user, errors }: Props) {
  return (
    <>
      <Head title="Profile settings" />

      <SettingsLayout>
        <ContentSection
          title="Profile"
          description="This is how others see you on the workspace."
        >
          <ProfileForm user={user} pageErrors={errors} />
        </ContentSection>
      </SettingsLayout>
    </>
  )
}

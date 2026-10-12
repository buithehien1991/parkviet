import { Head } from '@inertiajs/react'

import { AccountForm } from '@/components/admin/settings/account-form'
import { ContentSection } from '@/components/admin/settings/content-section'
import { SettingsLayout } from '@/components/admin/settings/settings-layout'
import type { AdminSettingsUser } from '@/types'

type Props = {
  user: AdminSettingsUser
  settings: Record<string, unknown>
  errors?: Record<string, string>
}

export default function AdminSettingsAccount({ user, errors }: Props) {
  return (
    <>
      <Head title="Account settings" />

      <SettingsLayout>
        <ContentSection
          title="Account"
          description="Update your account credentials and identity fields."
        >
          <AccountForm user={user} pageErrors={errors} />
        </ContentSection>
      </SettingsLayout>
    </>
  )
}

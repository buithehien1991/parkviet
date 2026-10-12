class AddPermissionRoles < ActiveRecord::Migration[8.1]
  class MigrationRole < ApplicationRecord
    self.table_name = "roles"
  end

  class MigrationPermission < ApplicationRecord
    self.table_name = "permissions"
  end

  class MigrationRolePermission < ApplicationRecord
    self.table_name = "role_permissions"
  end

  PERMISSION_PAIRS = [
    [ "Admin", "manage" ],
    [ "User", "read" ],
    [ "User", "create" ],
    [ "User", "update" ],
    [ "User", "delete" ],
    [ "Role", "read" ],
    [ "Role", "create" ],
    [ "Role", "update" ],
    [ "Role", "delete" ],
    [ "Permission", "read" ]
  ].freeze

  def up
    create_table :roles do |t|
      t.string :name, null: false
      t.string :key, null: false
      t.boolean :builtin, default: false, null: false
      t.boolean :admin, default: false, null: false
      t.integer :position, default: 0, null: false
      t.timestamps
    end

    add_index :roles, :key, unique: true

    create_table :permissions do |t|
      t.string :subject, null: false
      t.string :action, null: false
      t.timestamps
    end

    add_index :permissions, %i[subject action], unique: true

    create_table :role_permissions do |t|
      t.references :role, null: false
      t.references :permission, null: false
      t.timestamps
    end

    add_index :role_permissions, %i[role_id permission_id], unique: true

    add_reference :users, :role, null: true

    seed_builtin_roles_and_permissions
    backfill_user_role_records
  end

  def down
    remove_reference :users, :role
    drop_table :role_permissions
    drop_table :permissions
    drop_table :roles
  end

  private

  def seed_builtin_roles_and_permissions
    admin_role = MigrationRole.create!(name: "Admin", key: "admin", builtin: true, admin: true, position: 0)
    MigrationRole.create!(name: "User", key: "user", builtin: true, admin: false, position: 10)

    PERMISSION_PAIRS.each do |subject, action|
      permission = MigrationPermission.create!(subject:, action:)
      MigrationRolePermission.create!(role_id: admin_role.id, permission_id: permission.id)
    end
  end

  def backfill_user_role_records
    role_ids = MigrationRole.pluck(:key, :id).to_h

    execute <<~SQL.squish
      UPDATE users
      SET role_id = CASE role
        WHEN 1 THEN #{role_ids.fetch("admin")}
        ELSE role_id
      END
      WHERE role = 1
    SQL
  end
end

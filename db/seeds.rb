ActiveRecord::Base.transaction do
  admin_role = Role.find_or_create_by!(key: "admin") { |role| role.name = "Admin"; role.admin = true; role.builtin = true }
  Role.find_or_create_by!(key: "user") { |role| role.name = "User"; role.builtin = true }
  PermissionCatalog.all_pairs.each do |subject, action|
    permission = Permission.find_or_create_by!(subject:, action:)
    RolePermission.find_or_create_by!(role: admin_role, permission:)
  end
end

# No demo accounts, passwords, products, customers or invoices are seeded.

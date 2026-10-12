class Ability
  include CanCan::Ability

  def initialize(user)
    return unless user

    if user.admin_access?
      can :manage, :all
      can :manage, :admin
      return
    end

    apply_role_permissions(user.role_record)
  end

  private

  def apply_role_permissions(role)
    return unless role

    role.permissions.each do |permission|
      can PermissionCatalog.cancan_actions(permission.action), PermissionCatalog.cancan_subject(permission.subject)
    end
  end
end

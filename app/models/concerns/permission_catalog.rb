module PermissionCatalog
  ACTIONS_BY_SUBJECT = {
    "Admin" => %w[manage],
    "User" => %w[read create update delete],
    "Role" => %w[read create update delete],
    "Permission" => %w[read]
  }.freeze

  ACTION_MAP = {
    "read" => %i[read index show],
    "create" => %i[create new],
    "update" => %i[update edit],
    "delete" => %i[destroy],
    "manage" => %i[manage]
  }.freeze

  SUBJECTS = {
    "Admin" => :admin,
    "User" => "User",
    "Role" => "Role",
    "Permission" => "Permission"
  }.freeze

  module_function

  def all_pairs
    ACTIONS_BY_SUBJECT.flat_map { |subject, actions| actions.map { |action| [ subject, action ] } }
  end

  def action?(subject, action)
    ACTIONS_BY_SUBJECT.fetch(subject.to_s, []).include?(action.to_s)
  end

  def cancan_actions(action)
    ACTION_MAP.fetch(action.to_s, [ action.to_sym ])
  end

  def cancan_subject(subject)
    value = SUBJECTS.fetch(subject.to_s)
    value.is_a?(String) ? value.safe_constantize : value
  end
end

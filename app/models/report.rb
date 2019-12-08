class Report < ApplicationRecord
  belongs_to :reportable, polymorphic: true, optional: true
  belongs_to :user
  belongs_to :store

  enum status: {open: 0, in_progress: 1, on_hold: 2, closed: 3}
end

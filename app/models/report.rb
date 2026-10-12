class Report < ApplicationRecord
  include StoreScoped
  enum :status, { open: 0, in_progress: 1, on_hold: 2, closed: 3 }
  validates :title, presence: true
end

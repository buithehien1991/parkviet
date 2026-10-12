class PrintTemplate < ApplicationRecord
  include StoreScoped
  validates :name, presence: true
  validates :size, inclusion: { in: %w[a4 a5 k80 k58] }
  validates :template_type, inclusion: { in: %w[invoice purchase purchase_order] }
end

class PrintTemplate < ApplicationRecord
  belongs_to :user, optional: true
  enum size: {a4: 0, a5: 1, k80: 2, k58: 3}
  enum type: {invoice: 0, purchase: 1, purchase_order: 2}
end

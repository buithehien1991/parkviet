module StoreScoped
  extend ActiveSupport::Concern

  included do
    belongs_to :store
    belongs_to :user
    scope :by_store, ->(store_id) { where(store_id:) }
  end

  private

  def validate_store_association(name)
    record = public_send(name)
    errors.add(name, "không thuộc cửa hàng này") if record && record.store_id != store_id
  end
end

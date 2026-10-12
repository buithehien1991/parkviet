class Member < ApplicationRecord
  belongs_to :store
  belongs_to :user
  belongs_to :store_role
  belongs_to :branch, optional: true
  validates :user_id, uniqueness: { scope: :store_id }
  validate :same_store

  private

  def same_store
    errors.add(:store_role, "không thuộc cửa hàng") if store_role && store_role.store_id != store_id
    errors.add(:branch, "không thuộc cửa hàng") if branch && branch.store_id != store_id
    errors.add(:user, "chủ cửa hàng không thể là nhân viên") if store && store.user_id == user_id
  end
end

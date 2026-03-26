class DailyMenu < ApplicationRecord
  belongs_to :user
  belongs_to :menu

  validates :date, presence: true
  validates :user_id, uniqueness: { scope: :date }

  validate :menu_belongs_to_user

  private

  def menu_belongs_to_user
    return if menu.blank? || menu.user_id == user_id
    errors.add(:menu, "は自分の献立ではありません")
  end
end

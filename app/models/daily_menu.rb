class DailyMenu < ApplicationRecord
  belongs_to :user
  belongs_to :menu

  validates :date, presence: true
  validates :user_id, uniqueness: { scope: :date }

  validate :menu_belongs_to_user

  def start_time
    date.in_time_zone
  end

  def self.total_pfc(daily_menus)
    {
      protein: daily_menus.sum { |dm| dm.menu&.protein.to_i },
      fat:     daily_menus.sum { |dm| dm.menu&.fat.to_i },
      carb:    daily_menus.sum { |dm| dm.menu&.carb.to_i }
    }
  end

  private

  def menu_belongs_to_user
    return if menu.blank? || menu.user_id == user_id
    errors.add(:menu, "は自分の献立ではありません")
  end
end

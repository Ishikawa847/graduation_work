class Recipe < ApplicationRecord
  has_one_attached :image
  
  validates :image, presence: true
  validates :name, presence: true
  validates :description, presence: true, length: { maximum: 1000 }

  belongs_to :user

  has_many :recipe_ingredients, dependent: :destroy
  has_many :ingredients, through: :recipe_ingredients 

  accepts_nested_attributes_for :recipe_ingredients, 
                                allow_destroy: true,
                                reject_if: :reject_ingredient?
  
  private

  def reject_ingredient?(attributes)
  # 以下の条件のいずれかに該当する場合は除外（trueを返す）
  attributes['name'].blank? ||          # 材料名が空
  attributes['quantity'].blank? ||                 # 分量が空
  (attributes['protein'].blank? &&        # タンパク質が空 かつ
   attributes['fat'].blank? &&            # 脂質が空 かつ
   attributes['carb'].blank?)     # 炭水化物が空
  end
end

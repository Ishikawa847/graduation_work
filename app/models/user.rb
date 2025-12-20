class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  enum gender: { 
    男性: 0, 
    女性: 1, 
    その他: 2, 
    選択しない: 3 
  }

  validates :name, presence: true, length: { maximum: 100 }
  validates :height, numericality: { greater_than: 0, less_than: 300 }, allow_blank: true
  validates :weight, numericality: { greater_than: 0, less_than: 500 }, allow_blank: true
  validates :age, numericality: { greater_than: 0, less_than: 150 }, allow_blank: true

  has_many :recipes, dependent: :destroy
  has_many :menus, dependent: :destroy
end

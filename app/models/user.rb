class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  enum gender: { 
    male: 0, 
    female: 1, 
    other: 2, 
    prefer_not_to_say: 3 
  }

  validates :name, presence: true, length: { maximum: 100 }
  validates :height, numericality: { greater_than: 0, less_than: 300 }, allow_blank: true
  validates :weight, numericality: { greater_than: 0, less_than: 500 }, allow_blank: true
  validates :age, numericality: { greater_than: 0, less_than: 150 }, allow_blank: true

  has_many :boards, dependent: :destroy
end

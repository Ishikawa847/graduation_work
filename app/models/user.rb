class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :omniauthable, omniauth_providers: [ :google_oauth2 ]

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

  has_many :recipes, dependent: :destroy
  has_many :menus, dependent: :destroy

  def self.from_omniauth(auth)
    where(provider: auth.provider, uid: auth.uid).first_or_create do |user|
      user.email = auth.info.email
      user.password = Devise.friendly_token[0, 20]
      user.name = auth.info.name # nameカラムがある場合
      # user.image = auth.info.image # 画像を保存する場合
    end
  end
end

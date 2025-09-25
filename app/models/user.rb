class User < ApplicationRecord
  # パスワードハッシュ
  has_secure_password

  # 投稿写真
  has_many :photos, dependent: :destroy

  # ログインID（重複不可）
  validates :user_id, presence: true, uniqueness: true
end

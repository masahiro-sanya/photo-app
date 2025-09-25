class Photo < ApplicationRecord
  # 投稿者
  belongs_to :user
  # 画像（Active Storage）
  has_one_attached :image

  validates :title, presence: true, length: { maximum: 30 }
  validate :image_must_be_attached

  private

  # 画像は必須
  def image_must_be_attached
    errors.add(:image, "を選択してください") unless image.attached?
  end
end

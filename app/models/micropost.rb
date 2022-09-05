class Micropost < ApplicationRecord
  belongs_to :user

  has_one_attached :image

  validates :user_id, presence: true
  validates :content, presence: true,
                      length: {maximum: Settings.micropost.content_max_length}
  validates :image, content_type: {in: Settings.micropost.image_type,
                                   message: I18n.t("microposts.invalid_type")},
                    size: {less_than: Settings.micropost.image_size.megabytes,
                           message: I18n.t("microposts.invalid_size")}

  scope :recent, ->{order created_at: :desc}
  scope :search_by_id, ->(id){where "user_id = ?", id}

  delegate :name, to: :user, prefix: true

  def display_image
    image.variant(resize_to_limit: Settings.micropost.resize_to_limit)
  end
end

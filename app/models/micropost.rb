class Micropost < ApplicationRecord
  belongs_to :user
  scope :sort_post, ->{order(created_at: :desc)}
  scope :feed, ->(id){where user_id: id}
  mount_uploader :picture, PictureUploader
  validates :content, presence: true,
                      length: {maximum: Settings.length.max_content}
  validate  :picture_size

  private

  def picture_size
    return unless picture.size > Settings.size_picture.megabytes
    errors.add(:picture, I18n.t("micropost.warning_size_img"))
  end
end

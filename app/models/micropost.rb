class Micropost < ApplicationRecord
  belongs_to :user
  scope :sort_post, ->{order(created_at: :desc)}
  scope :feed, (lambda do |id|
    following_ids = "SELECT followed_id FROM relationships
      WHERE follower_id = :user_id"
    where("user_id IN (#{following_ids}) OR user_id = :user_id", user_id: id)
  end)
  mount_uploader :picture, PictureUploader
  validates :content, presence: true,
                      length: {maximum: Settings.length.max_content}
  validate  :picture_size

  private

  def picture_size
    return unless picture.size > Settings.size_picture.megabytes
    errors.add :picture, I18n.t("micropost.warning_size_img")
  end
end

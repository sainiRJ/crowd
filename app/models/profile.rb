class Profile < ApplicationRecord
  belongs_to :user
  has_one_attached :file
  attribute :profile_photo, :string
  has_one_attached :video_file
 
  attribute :cover_photo, :string
  

end

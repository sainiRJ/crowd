class Post < ApplicationRecord
  belongs_to :user
  has_one_attached :file
  attribute :file, :string
  has_many :comments, dependent: :destroy
end

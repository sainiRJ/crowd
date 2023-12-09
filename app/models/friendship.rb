class Friendship < ApplicationRecord
  belongs_to :user
  belongs_to :friend, class_name: 'User', foreign_key: 'friend_id'
  enum status: { pending: 0, accepted: 1, declined: 2 }
end

class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
    has_secure_password
    has_one :profile
    has_many :messages
    has_many :posts

    # serialize :friend_requests_sent, Array
    # serialize :friend_requests_received, Array
    # serialize :friends, Array

    scope :all_except, ->(user) { where.not(id: user) }
    after_create_commit { broadcast_append_to "users" }

    
    has_many :friendships, foreign_key: 'user_id', dependent: :destroy
    has_many :friends, through: :friendships, source: 'friend'
    has_many :pending_friend_requests, -> { where(status: :pending) }, class_name: 'Friendship', foreign_key: 'friend_id'
  
  
    def friend_with?(other_user)
        friendships.exists?(friend: other_user, status: :accepted)
      end
end


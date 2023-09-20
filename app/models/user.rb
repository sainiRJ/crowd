class User < ApplicationRecord
    has_secure_password
    has_one :profile
    serialize :friend_requests_sent, Array
    serialize :friend_requests_received, Array
    serialize :friends, Array
end

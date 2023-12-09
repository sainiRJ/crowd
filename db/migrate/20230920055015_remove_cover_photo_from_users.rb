class RemoveCoverPhotoFromUsers < ActiveRecord::Migration[7.0]
  def change
    remove_column :users, :cover_photo, :string
  end
end

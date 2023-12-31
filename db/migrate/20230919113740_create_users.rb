class CreateUsers < ActiveRecord::Migration[7.0]
  def change
    create_table :users do |t|
      t.string :name
      t.string :mobile_number
      t.string :email
      t.date :birthday
      t.string :gender
      t.string :profile_photo
      t.string :cover_photo
      t.string :password_digest

      t.timestamps
    end
  end
end

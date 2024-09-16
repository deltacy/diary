class AddCalendarTokenToUser < ActiveRecord::Migration[7.2]
  def change
    add_column :users, :calendar_token, :string
    add_index :users, :calendar_token, unique: true
    add_column :users, :calendar_token_create_at, :timestamp
  end
end

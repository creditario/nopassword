# This migration comes from no_password (originally 20211202211706)
class CreateNoPasswordSessions < ActiveRecord::Migration[7.0]
  def change
    create_table :no_password_sessions, if_not_exists: true do |t|

      t.timestamp :expires_at
      t.timestamp :claimed_at
      t.string :token, null: false
      t.string :user_agent, null: false
      t.string :remote_addr, null: false
      t.string :return_url
      t.string :email, null: false

      t.timestamps
    end
  end
end

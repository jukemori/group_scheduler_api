class CreateCalendarInvitations < ActiveRecord::Migration[7.1]
  def change
    create_table :calendar_invitations do |t|
      t.references :calendar, null: false, foreign_key: true
      t.references :user, null: false, foreign_key: true
      t.integer :status

      t.timestamps
    end

    add_index :calendar_invitations, [:calendar_id, :user_id], unique: true
  end
end

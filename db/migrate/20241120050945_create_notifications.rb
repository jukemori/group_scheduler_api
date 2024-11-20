class CreateNotifications < ActiveRecord::Migration[7.1]
  def change
    create_table :notifications do |t|
      t.references :user, null: false, foreign_key: true
      t.references :calendar, null: false, foreign_key: true
      t.references :event, null: true, foreign_key: true
      t.references :calendar_note, null: true, foreign_key: true
      t.references :calendar_invitation, null: true, foreign_key: true
      t.string :action
      t.string :message
      t.boolean :read, default: false

      t.timestamps
    end
  end
end

class CreateCalendarNotes < ActiveRecord::Migration[7.1]
  def change
    create_table :calendar_notes do |t|
      t.text :content
      t.references :calendar, null: false, foreign_key: true
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end

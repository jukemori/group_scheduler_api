class CreateEvents < ActiveRecord::Migration[7.1]
  def change
    create_table :events do |t|
      t.string :subject
      t.text :description
      t.datetime :start_time
      t.datetime :end_time
      t.string :start_timezone
      t.string :end_timezone
      t.boolean :is_all_day
      t.boolean :is_block
      t.boolean :is_readonly
      t.string :location
      t.string :recurrence_rule
      t.string :recurrence_exception
      t.integer :recurrence_id
      t.integer :following_id
      t.references :user, null: false, foreign_key: true
      t.references :calendar, null: false, foreign_key: true

      t.timestamps
    end
  end
end
class AddForeignKeyToCalendarsCreator < ActiveRecord::Migration[7.1]
  def change
    add_foreign_key :calendars, :users, column: :creator_id
  end
end

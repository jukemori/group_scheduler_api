class CreateCalendarsUsers < ActiveRecord::Migration[7.1]
  def change
    create_table :calendars_users, id: false do |t|
      t.belongs_to :user, null: false
      t.belongs_to :calendar, null: false
    end
  end
end

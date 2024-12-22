class AddCreatorIdToCalendars < ActiveRecord::Migration[7.1]
  def change
    add_column :calendars, :creator_id, :integer
    add_index :calendars, :creator_id
  end
end

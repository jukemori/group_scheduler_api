class CreateJoinTableUsersCalendars < ActiveRecord::Migration[7.1]
  def change
    create_join_table :users, :calendars do |t|
      # t.index [:user_id, :calendar_id]
      # t.index [:calendar_id, :user_id]
    end
  end
end

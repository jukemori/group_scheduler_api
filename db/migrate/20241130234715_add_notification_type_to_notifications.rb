class AddNotificationTypeToNotifications < ActiveRecord::Migration[7.1]
  def change
    add_column :notifications, :notification_type, :string

    reversible do |dir|
      dir.up do
        Notification.find_each do |notification|
          type = if notification.event_id.present?
            'event'
          elsif notification.calendar_note_id.present?
            'note'
          elsif notification.calendar_invitation_id.present?
            'invitation'
          end
          
          notification.update_column(:notification_type, type)
        end
      end
    end
  end
end

class SendDirectNotificationJob < ApplicationJob
  queue_as :default

  def perform(device_token, message_title, message_body)
    PushNotificationService.new.deliver_direct(device_token, message_title, message_body)
  end
end

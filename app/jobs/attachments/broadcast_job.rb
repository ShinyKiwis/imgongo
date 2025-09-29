class Attachments::BroadcastJob < ApplicationJob
  include ActionView::RecordIdentifier

  queue_as :default 

  ALLOWED_EVENTS = %w(new_attachment update_attachment)

  def perform(event, attachment)
    return unless event.in?(ALLOWED_EVENTS)

    @event = event
    @attachment = attachment

    Turbo::StreamsChannel.send(
      broadcast_event,
      dom_id(attachment.album),
      target: broadcast_target,
      partial: 'attachments/attachment',
      locals: { attachment: attachment }
    )
  end

  private

  attr_reader :event
  attr_reader :attachment

  def broadcast_event
    {
      new_attachment: 'broadcast_prepend_to',
      update_attachment: 'broadcast_replace_to'
    }.with_indifferent_access.fetch(event)
  end

  def broadcast_target
    {
      new_attachment: dom_id(attachment.album, :show),
      update_attachment: dom_id(attachment)
    }.with_indifferent_access.fetch(event)
  end
end

class Attachments::BroadcastJob < ApplicationJob
  include ActionView::RecordIdentifier

  queue_as :default 

  ALLOWED_EVENTS = %w(new_attachment update_attachment)

  def perform(event, attachment)
    return unless event.in?(ALLOWED_EVENTS)

    @event = event
    @attachment = attachment

    Turbo::StreamsChannel.send(
      stream_action,
      dom_id(attachment.album),
      target: broadcast_target,
      partial: broadcast_template,
      locals: { attachment: attachment }
    )
  end

  private

  attr_reader :event
  attr_reader :attachment

  def stream_action
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

  def broadcast_template
    {
      new_attachment: 'attachments/attachment',
      update_attachment: 'attachments/show'
    }.with_indifferent_access.fetch(event)
  end
end

module ComponentsHelper
  def action_button(text, path, options = {})
    link_options = {
      data: {
        turbo_stream: options[:turbo_stream],
        turbo_frame: options[:turbo_frame]
      }.compact
    }
    link_options[:class] = options[:class]

    link_to path, link_options do
      concat(icon options[:icon], variant: 'solid', class: 'w-4') if options[:icon]
      concat text
    end
  end

  # hidden value is used for confirmation modal only!
  def modal(id: nil, title: nil, hidden: false, closable: true, &block)
    content_tag :dialog, id: id, class: 'modal', data: { controller: 'modal', modal_target: 'dialog', modal_hidden_value: hidden } do
      concat(content_tag(:div, class: 'modal-header') do
        concat(content_tag(:span, title))
        if closable
          concat(icon 'x-mark', variant: 'solid', class: 'w-6 text-zinc-800 cursor-pointer', data: { action: 'click->modal#toggle' })
        end
      end)
      concat(content_tag(:div, capture(&block), class: "modal-content"))
    end
  end
end

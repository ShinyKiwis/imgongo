module ComponentsHelper
  def action_button(text, path, options = {})
    link_options = {}
    link_options[:class] = options[:class]
    if options[:toggle].present?
      link_options[:data] = {
        controller: 'modal',
        action: 'click->modal#toggle',
        toggle: options[:toggle],
      }
    end
    link_options[:data][:turbo_stream] = options[:turbo_stream]

    link_to path, link_options do
      concat icon options[:icon] if options[:icon]
      concat text
    end
  end

  def modal(id:, title:, &block)
    content_tag :div, id: id, class: "hidden", data: { controller: 'modal', toggle: id } do
      concat(content_tag(:div, "", class: "modal-overlay", data: { action: 'click->modal#toggle' }))
      concat(content_tag(:div, class: 'modal') do
        concat(content_tag(:div, class: 'modal-header') do
          concat(content_tag(:span, title))
          concat(icon 'x-mark', variant: 'solid', class: 'w-6 text-zinc-800 cursor-pointer', data: { action: 'click->modal#toggle' })
        end)
        concat(content_tag(:div, capture(&block), class: "modal-content"))
      end)
    end
  end
end

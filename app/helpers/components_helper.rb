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
      concat icon options[:icon] if options[:icon]
      concat text
    end
  end

  def modal(id:, title:, closable: true, &block)
    content_tag :div, id: id, data: { controller: 'modal', toggle: id } do
      concat(content_tag(:div, "", class: "modal-overlay", data: { action: 'click->modal#toggle' }))
      concat(content_tag(:div, class: 'modal') do
        concat(content_tag(:div, class: 'modal-header') do
          concat(content_tag(:span, title))
          if closable
            concat(icon 'x-mark', variant: 'solid', class: 'w-6 text-zinc-800 cursor-pointer', data: { action: 'click->modal#toggle' })
          end
        end)
        concat(content_tag(:div, capture(&block), class: "modal-content"))
      end)
    end
  end
end

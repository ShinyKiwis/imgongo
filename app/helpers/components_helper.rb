module ComponentsHelper
  def action_button(text, path, options = {})
    link_options = {}
    link_options[:class] = options[:class]

    link_to path, link_options do
      concat icon options[:icon] if options[:icon]
      concat text
    end
  end
end

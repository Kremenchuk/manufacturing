module ApplicationHelper

  def select_controller_helper(name = nil, options = nil, html_options = nil, &block)
    html_options, options, name = options, name, block if block_given?
    options ||= {}

    html_options = convert_options_to_data_attributes(options, html_options)

    url = url_for(options)
    html_options["href".freeze] ||= url

    content_tag("a".freeze, name || url, html_options, &block)
  end
end

module ApplicationHelper
  def check_box_helper(options = {})
    input_body = ''
    input_body += " class='#{options[:class_name]}'" if options[:class_name].present?
    input_body += " name='#{options[:name]}#{options[:field_name]}'"
    input_body += " style:'#{options[:style]}'" if options[:style].present?
    input_body += ' checked' if options[:checked].present?
    input_body += ' disabled' if options[:disabled].present?
    input_body += " #{options[:data]}" if options[:data].present?
    input_body += " id='id_#{options[:id]}'" if options[:id].present?
    "<input type='checkbox' #{input_body} value=#{options[:value]} />"
  end

  def radio_helper(value, name = nil, field_name = nil, class_name = nil, data = nil)
    input_body = ''
    input_body += " class='#{class_name}'" if class_name.present?
    input_body +=" name='#{name}#{field_name}' id='id_#{name}_#{value}'" if name.present?
    input_body +=" #{data}" if data.present?
    "<input type='radio' #{input_body} value=#{value}>"
  end

  def text_helper(options = {})
    input_body = ''
    input_body += " class='#{options[:class_name]}'" if options[:class_name].present?
    input_body += " name='#{options[:name]}#{options[:field_name]}'"
    input_body += " id='id_#{options[:id]}'" if options[:id].present?
    input_body += " style:'#{options[:style]}'" if options[:style].present?
    input_body += ' hidden' if !options[:visible].nil?
    "<input type='text' #{input_body} value=#{options[:value]}>"
  end
end

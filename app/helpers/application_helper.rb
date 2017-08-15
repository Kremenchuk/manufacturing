module ApplicationHelper
  def check_box_helper(value, name = nil, field_name = nil, class_name = nil, style = nil)
    input_body = " class='#{class_name}'" if class_name.present?
    input_body += " name='#{name}#{field_name}' id='id_#{name}_#{value}'" if name.present?
    input_body += " style:'#{style}'" if style.present?
    "<input value=#{value} type='checkbox' #{input_body}>"
  end

  def radio_helper(value, name = nil, field_name = nil, class_name = nil, data = nil)
    input_body = " class='#{class_name}'" if class_name.present?
    input_body +=" name='#{name}#{field_name}' id='id_#{name}_#{value}'" if name.present?
    input_body +=" #{data}" if data.present?
    "<input value=#{value} type='radio' #{input_body}>"
  end
end

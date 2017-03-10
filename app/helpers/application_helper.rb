module ApplicationHelper
  def check_box_helper(value, name = nil, field_name = nil,class_name = nil)
    input_body = (" class='#{class_name}'" if class_name.present?) +
        (" name='#{name}#{field_name}' id='id_#{name}_#{value}'" if name.present?)
    "<input value=#{value} type='checkbox' #{input_body}>"
  end
end

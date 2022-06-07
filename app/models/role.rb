# == Schema Information
#
# Table name: roles
#
#  id                :integer          not null, primary key
#  available_classes :string
#  name              :string
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#
class Role < ApplicationRecord
  has_many :users

end

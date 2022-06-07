# == Schema Information
#
# Table name: workers
#
#  id         :integer          not null, primary key
#  fio        :string           not null
#  position   :string           not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
class Worker < ApplicationRecord

  has_many :payrolls, dependent: :destroy

  validates :fio, presence: true
  validates :position, presence: true

end

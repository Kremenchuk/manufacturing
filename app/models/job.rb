# == Schema Information
#
# Table name: jobs
#
#  id                  :integer          not null, primary key
#  name                :string           not null
#  name_for_print      :string           not null
#  price               :float            not null
#  print_in_collection :boolean          default(TRUE)
#  time                :integer          not null
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#
class Job < ApplicationRecord

  has_many :item_details, as: :detailable

  validates :name, :price, :time, :name_for_print,
            presence: true

  default_scope { order(created_at: :desc) }

  def as_json(options = nil)
    {
      id: id,
      name: name,
      price: price,
      time: time
    }
  end

end

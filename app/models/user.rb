# == Schema Information
#
# Table name: users
#
#  id                     :integer          not null, primary key
#  current_sign_in_at     :datetime
#  current_sign_in_ip     :string
#  email                  :string           default(""), not null
#  encrypted_password     :string           default(""), not null
#  last_sign_in_at        :datetime
#  last_sign_in_ip        :string
#  locale                 :string           default("ru")
#  remember_created_at    :datetime
#  reset_password_sent_at :datetime
#  reset_password_token   :string
#  sign_in_count          :integer          default(0), not null
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#  role_id                :integer
#
# Indexes
#
#  index_users_on_email                 (email) UNIQUE
#  index_users_on_reset_password_token  (reset_password_token) UNIQUE
#  index_users_on_role_id               (role_id)
#
class User < ApplicationRecord
  # Include default devise modules. Others available are:
  #:registerable,
  # :confirmable, :lockable, :timeoutable and :omniauthable

  before_save { |user| user.locale = user.locale.downcase }

  devise :database_authenticatable,
         :recoverable, :rememberable, :trackable, :validatable, :timeoutable

  belongs_to :role
  has_many :order_manufacturings

end

class User < ApplicationRecord
  # Include default devise modules. Others available are:
  #:registerable,
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable,
         :recoverable, :rememberable, :trackable, :validatable, :timeoutable

  belongs_to :role
  has_many :order_manufacturings

end

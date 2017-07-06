class User < ApplicationRecord
  has_many :connections
  has_many :machines, through: :connections 
  
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
         
  validates :first_name, :last_name, presence: true
end

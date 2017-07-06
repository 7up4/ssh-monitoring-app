class Machine < ApplicationRecord
  has_many :connections, dependent: :destroy
  has_many :users, through: :connections

  accepts_nested_attributes_for :connections, allow_destroy: true
  
  validates :ssh_user, :ssh_host, presence: true
end

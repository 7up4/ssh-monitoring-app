class Connection < ApplicationRecord
  belongs_to :user
  belongs_to :machine
  
  accepts_nested_attributes_for :machine
end

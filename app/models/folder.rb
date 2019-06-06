class Folder < ApplicationRecord
  acts_as_tree

  belongs_to :user

  validates_presence_of :name

end

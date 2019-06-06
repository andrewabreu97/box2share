class Folder < ApplicationRecord
  acts_as_tree

  belongs_to :user
  has_many :assets, dependent: :destroy

  validates_presence_of :name

end

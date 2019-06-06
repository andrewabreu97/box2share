class Folder < ApplicationRecord
  acts_as_tree

  belongs_to :user
end

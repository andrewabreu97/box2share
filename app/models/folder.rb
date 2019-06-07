class Folder < ApplicationRecord
  acts_as_tree

  belongs_to :user
  has_many :assets, dependent: :destroy

  validates_presence_of :name
  validates_uniqueness_of :name, scope: :parent_id

  def files_and_subfolders_count
    assets.count + children.count
  end

end

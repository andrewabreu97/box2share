class Asset < ApplicationRecord
  belongs_to :user
  belongs_to :folder, optional: true
  has_one_attached :uploaded_file
  validates :uploaded_file, attached: true
  validates_presence_of :name
end

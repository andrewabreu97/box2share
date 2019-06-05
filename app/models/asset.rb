class Asset < ApplicationRecord
  belongs_to :user
  has_one_attached :uploaded_file
  validates :uploaded_file, attached: true
end

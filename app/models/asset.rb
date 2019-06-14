class Asset < ApplicationRecord
  belongs_to :user
  belongs_to :folder, optional: true

  has_one_attached :uploaded_file

  validates :uploaded_file, attached: true, size: { less_than: 5.gigabytes, message: "El tamaño del fichero debe ser menor a 5 gigabytes." }
  validates_presence_of :name
  validates_uniqueness_of :name, scope: [:folder_id, :user_id]
end

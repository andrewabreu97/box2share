class Asset < ApplicationRecord
  belongs_to :user
  belongs_to :folder, optional: true
  has_many :shared_assets

  has_one_attached :uploaded_file

  validates :uploaded_file, attached: true, size: { less_than: 5.gigabytes, message: "El tamaño del archivo debe ser menor a 5 gigabytes." }
  validates_presence_of :name
  validates_uniqueness_of :name, scope: [:folder_id, :user_id]

  before_destroy :delete_uploaded_file

  def shared?
    !self.shared_assets.empty?
  end

  def members_count
    self.shared_assets.count
  end

  private
    def delete_uploaded_file
      self.uploaded_file.purge
    end

end

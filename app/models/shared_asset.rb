class SharedAsset < ApplicationRecord
  belongs_to :user
  belongs_to :asset
  belongs_to :shared_user, class_name: "User", foreign_key: "shared_user_id", optional: true

  validates_uniqueness_of :shared_email, scope: [:asset_id, :user_id]

  validates_presence_of :shared_email
  validates :shared_email, format: { with: /\A[^@\s]+@([^@.\s]+\.)+[^@.\s]+\z/ }

  before_create :create_shared_asset_digest

  has_secure_password validations: false

  def SharedAsset.digest(string)
    cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST :
                                                  BCrypt::Engine.cost
    BCrypt::Password.create(string, cost: cost)
  end

  def self.new_token
    SecureRandom.urlsafe_base64
  end

  def authenticated?(attribute, token)
    digest = send("#{attribute}_digest")
    return false if digest.nil?
    BCrypt::Password.new(digest).is_password?(token)
  end

  private
    def create_shared_asset_digest
      self.shared_asset_token = SharedAsset.new_token
      self.shared_asset_digest = SharedAsset.digest(shared_asset_token)
    end

end

class User < ApplicationRecord

  mount_uploader :avatar, AvatarUploader

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable, :confirmable

 	validates :name, presence: true
 	validates :last_name, presence: true
  #validates_presence_of :avatar
  validates_integrity_of :avatar
  validates_processing_of :avatar
  validate :avatar_size

  has_many :subscriptions
  has_many :payments

  def current_subscription
    subscriptions.where(status: "active").last
  end

  def current_plan?(plan_id)
    current_subscription.plan.id == plan_id
  end

  def full_name
    "#{name} #{last_name}"
  end

  def after_confirmation
    self.create_subscription(plan: Plan.free_plan.first, status: 0,
        type: 'FreeSubscription')
  end

  private
    def avatar_size
      if avatar.size > 5.megabytes
        errors.add(:avatar, "should be less than 5MB")
      end
    end

end

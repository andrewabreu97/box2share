class User < ApplicationRecord

  mount_uploader :avatar, AvatarUploader

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable, :confirmable
 	validates :name, presence: true
 	validates :last_name, presence: true
  validates_presence_of :avatar
  validates_integrity_of :avatar
  validates_processing_of :avatar

  has_many :subscriptions

  def subscriptions_in_cart
    subscriptions.waiting.all.to_a
  end

  def full_name
    "#{name} #{last_name}"
  end

end

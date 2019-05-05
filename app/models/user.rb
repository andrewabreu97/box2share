class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable, :confirmable
 	validates :name, presence: true
 	validates :last_name, presence: true

  has_many :subscriptions

  def subscriptions_in_cart
    subscriptions.waiting.all.to_a
  end

end

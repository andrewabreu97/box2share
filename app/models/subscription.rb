class Subscription < ApplicationRecord

  belongs_to :user
  belongs_to :plan

  validates_presence_of :type

  enum status: {active: 0, inactive: 1,
                waiting: 2, pending_initial_payment: 3,
                canceled: 4}

  delegate :name, to: :plan

  scope :free_subscription, -> { where(type: 'FreeSubscription') }
  scope :paid_subscription, -> { where(type: 'PaidSubscription' ) }

  def free?
    type == 'FreeSubscription'
  end

end

class Plan < ApplicationRecord
  has_many :subscriptions

  enum status: {inactive: 0, active: 1}

  validates_presence_of :name
  validates_presence_of :type

  scope :free_plan, -> { where(type: 'FreePlan') }
  scope :paid_plan, -> { where(type: 'PaidPlan') }

end

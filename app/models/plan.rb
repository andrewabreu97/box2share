class Plan < ApplicationRecord

  enum status: {inactive: 0, active: 1}
  enum interval: {day: 0, week: 1, month: 2, year: 3}

  monetize :price_cents

  def remote_plan
    @remote_plan ||= Stripe::Plan.retrieve(remote_id)
  end

end

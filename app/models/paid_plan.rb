class PaidPlan < Plan

  enum interval: {day: 0, week: 1, month: 2, year: 3}

  monetize :price_cents

  validates_presence_of :remote_id, :interval, :interval_count

  def remote_plan
    @remote_plan ||= Stripe::Plan.retrieve(remote_id)
  end

  def end_date_from(date = nil)
    date ||= Date.current.to_date
    interval_count.send(interval).from_now(date)
  end

end

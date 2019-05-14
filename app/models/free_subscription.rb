class FreeSubscription < Subscription

  validates :start_date, :end_date, :payment_method,
  :remote_id, absence: true

end

class CreatesPlan

  attr_accessor :remote_id, :name,
      :price_cents, :interval,
      :space_allowed, :plan

  def initialize(remote_id:, name:,
    price_cents:, interval:, space_allowed:)
    @remote_id = remote_id
    @name = name
    @price_cents = price_cents
    @space_allowed = space_allowed
  end

  def run
    remote_plan = Stripe::Plan.create(
        id: remote_id, amount: price_cents,
        currency: "usd", interval: interval,
        name: name)
    self.plan = Plan.create(
        remote_id: remote_plan.id, name: name,
        price_cents: price_cents, interval: interval,
        space_allowed: space_allowed,
        status: :active)
  end

end

class CreatesFreePlan

  attr_accessor :name, :space_allowed, :plan

  def initialize(name:, space_allowed:)
    @name = name
    @space_allowed = space_allowed
  end

  def run
    self.plan = Plan.create(
        name: name, space_allowed: space_allowed, status: :active, type: 'FreePlan')
  end

end

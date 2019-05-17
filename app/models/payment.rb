class Payment < ApplicationRecord

  include HasReference

  belongs_to :user, optional: true
  has_many :payment_line_items, dependent: :destroy

  monetize :price_cents

  enum status: {created: 0, succeeded: 1, pending: 2, failed: 3}

end

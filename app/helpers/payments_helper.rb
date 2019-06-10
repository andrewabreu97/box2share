module PaymentsHelper

  def receipt_url(payment)
    json = JSON.parse(payment.full_response)
    json['receipt_url']
  end

end

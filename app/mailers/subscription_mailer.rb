class SubscriptionMailer < ApplicationMailer

  def successful_subscription(user, subscription)
    @user = user
    @subscription = subscription
    mail to: user.email, subject: "Suscripción exitosa al plan #{@subscription.name}"
  end

  def successful_payment(user, subscription, invoice)
    @user = user
    @subscription = subscription
    @invoice = invoice
    mail to: user.email, subject: "Pago exitoso"
  end

  def cancelled_subscription(user, subscription)
    @user = user
    @subscription = subscription
    mail to: user.email, subject: "Suscripción cancelada"
  end

end

class StripeWebhookController < ApplicationController
  before_action :check_signature, only: [:action]

  protect_from_forgery except: :action

  def action
    @event_data = JSON.parse(request.body.read)
    workflow = workflow_class.new(verify_event)
    workflow.run
    if workflow.success
      head :ok
    else
      head :internal_server_error
    end
  end

  private def verify_event
    Stripe::Event.retrieve(@event_data["id"])
  rescue Stripe::InvalidRequestError => e
    Rollbar.error(e)
    nil
  end

  private def workflow_class
    event_type = @event_data["type"]
    "StripeHandler::#{event_type.tr('.', '_').camelize}".constantize
  rescue NameError
    StripeHandler::NullHandler
  end

  private def check_signature
    payload = request.body.read
    signature_header = request.env['HTTP_STRIPE_SIGNATURE']
    singing_key = Rails.application.secrets.stripe_signing_key
    event = nil
    begin
      event = Stripe::Webhook.construct_event(
        payload, signature_header, singing_key
      )
    rescue JSON::ParserError => e
      Rollbar.error(e)
      head :bad_request
    rescue Stripe::SignatureVerificationError => e
      Rollbar.error(e)
      head :bad_request
    end
  end

end

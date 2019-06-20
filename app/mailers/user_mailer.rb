class UserMailer < ApplicationMailer

  def share_link_email(shared_asset)
    @shared_asset = shared_asset
    mail(to: @shared_asset.shared_email, subject: "#{@shared_asset.user.name} quiere compartir este archivo contigo.")
  end

end

# frozen_string_literal: true

class Ability
  include CanCan::Ability

  def initialize(user)

    can [:show, :edit, :update, :destroy, :share, :members], Asset, user_id: user.id
    can [:show, :new, :edit, :update, :destroy, :browse], Folder, user_id: user.id
    can [:show], SharedAsset, shared_user_id: user.id

    can :download, Asset do |asset|
      asset.user_id == user.id || asset.shared_assets.map(&:shared_user_id).include?(user.id)
    end

  end
end

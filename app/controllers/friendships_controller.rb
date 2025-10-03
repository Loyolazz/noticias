class FriendshipsController < ApplicationController
  before_action :require_login

  def create
    friend = User.find(params[:friend_id])
    friendship = current_user.friendships.build(friend: friend)

    if friendship.save
      redirect_back fallback_location: current_user, notice: t('flash.friend_added')
    else
      redirect_back fallback_location: current_user, alert: friendship.errors.full_messages.to_sentence
    end
  end

  def destroy
    friendship = current_user.friendships.find_by(id: params[:id]) ||
                 current_user.inverse_friendships.find_by(id: params[:id])

    if friendship
      friendship.destroy
      redirect_back fallback_location: current_user, notice: t('flash.friend_removed')
    else
      redirect_back fallback_location: current_user, alert: t('flash.friend_not_found')
    end
  end
end

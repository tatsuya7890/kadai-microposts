class FavoritesController < ApplicationController

  #事前処理
  before_action :require_user_logged_in

  #お気に入り登録処理
  def create
    micropost = Micropost.find(params[:micropost_id])
    current_user.favorite(micropost)
    flash[:success] = 'お気に入りに登録しました'
    redirect_to root_url
  end

  #お気に入り解除処理
  def destroy
    micropost = Micropost.find(params[:micropost_id])
    current_user.unfavorite(micropost)
    flash[:success] = 'お気に入りを解除しました'
    redirect_to root_url

  end
end

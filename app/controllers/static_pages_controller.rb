class StaticPagesController < ApplicationController
  def home
    return unless logged_in?
    @micropost  = current_user.microposts.build
    @feed_items = Micropost.feed(current_user.id).sort_post
                           .page(params[:page]).per Settings.per_page
  end

  def help; end

  def about; end

  def contact; end
end

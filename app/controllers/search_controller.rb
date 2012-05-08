class SearchController < ApplicationController
  before_filter :authenticate_user!

  def index
  	@search = params[:q]
  	@books = Book.search_filter_user :name => params[:q], :user_id => current_user.id, :page => params[:page]
  end

end

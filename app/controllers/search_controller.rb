class SearchController < ApplicationController
  before_filter :authenticate_user!

  def index  
    catalogs = Catalog.where(:user_id => current_user.id).all.map(&:id)
    shared_catalogs = SharedCatalog.includes(:catalog).where(:user_id => current_user.id).all.map(&:id)
    search(catalogs + shared_catalogs, 50)

    respond_to do |format|
      format.atom { render :atom => @books }
    end
  end

end

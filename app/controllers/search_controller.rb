class SearchController < ApplicationController
  before_filter :authenticate_user!

  def index
    search(50)

    respond_to do |format|
      format.atom { render :atom => @books }
    end
  end

  def opensearch

  	respond_to do |format|
			format.xml { render :opensearch }
		end
  end

end

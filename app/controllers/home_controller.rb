class HomeController < ApplicationController
  def index
    @public_catalogs = Catalog.all_public
  end

end

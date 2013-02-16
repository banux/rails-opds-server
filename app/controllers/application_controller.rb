class ApplicationController < ActionController::Base
  protect_from_forgery
  before_filter :authenticate_user!, :only => [:search]

   def search(catalogs_available = nil, per_page = 50)
    if current_user
      user_id = current_user.id
    end
    if params[:serie]
      book_sort = 'serie_number'
      book_sort_order = 'asc'
    end

    book_sort ||= 'created_at'
    book_sort_order ||= 'desc'

    @books = Book.where(:user_id => user_id).paginate(:page => params[:page], :per_page => per_page).order(book_sort + " " + book_sort_order.upcase)
    @books = @books.where(:serie => params[:serie]) if params[:serie]
    @books = @books.where(:author => params[:author]) if params[:author]
    @books = @books.where(:lang => params[:lang]) if params[:lang]
    if params[:q]
      query = '%' + params[:q] + '%'
      @books = @books.where("title LIKE ? OR description LIKE ?", query, query)
    end
    @books = @books.joins(:category).where('categories.id' => params[:category]) if params[:category]
    @books = @books.joins(:tags).where('tags.name' => params[:tag]) if params[:tag]
  end
end

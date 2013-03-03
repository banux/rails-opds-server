class ApplicationController < ActionController::Base
  protect_from_forgery
  before_filter :authenticate_user!, :only => [:search]
  before_filter :check_view

   def search(per_page = 50)
    logger.debug(@users.inspect)
    if @users.nil?
      users = [@user.id]
    else
      users = @users
    end
    logger.debug(@users.inspect)
    query = params[:q] if params[:q]
    tag = params[:tag] if params[:tag]

    if params[:author]
      filter_author = params[:author]
    end
    if params[:tag]
      filter_tag = params[:tag]
    end
    if params[:serie]
      filter_serie = params[:serie]
      book_sort = 'serie_number'
      book_sort_order = 'asc'
    end
    if params[:category]
      filter_category = params[:category]
    end
    if params[:lang]
      filter_lang = params[:lang]
    end

    book_sort ||= 'created_at'
    book_sort_order ||= 'desc' 

    @books = Book.search :page => (params[:page] || 1), :per_page => per_page, :load => true do
       query do 
        boolean do
          must { terms :user_id, users }
          must { string query } if query
          must { term :author_keyword, filter_author } if filter_author
          must { term :tags, filter_tag } if filter_tag
          must { term :serie_keyword, filter_serie } if filter_serie
          must { term :lang, filter_lang } if filter_lang
          must { term :category, filter_category } if filter_category
        end
      end    

      sort { by book_sort, book_sort_order }

      facet "author" do
        terms 'author_keyword'
      end
      facet "tag" do
        terms 'tags'
      end
      facet "serie" do
        terms 'serie_keyword'
      end

      facet "lang" do
        terms 'lang'
      end

      if filter_category
        regex_category = Category.find(filter_category).children.map(&:id).join('|')
      else        
        regex_category = Category.roots.map(&:id).join('|')
      end
      facet "category" do
        terms 'category', :regex_flags => "DOTALL", :regex => regex_category 
      end
    end
    @facets = @books.facets
  end

  private

  def check_view
    if params[:user_id]
      @user = User.find(params[:user_id])
    else
      @user = current_user
    end
    return true
  end
end

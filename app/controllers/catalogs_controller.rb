class CatalogsController < ApplicationController
  before_filter :authenticate_user!

  def index

  end

  def all    
    search(50)
    if params[:category]
      @categories = Category.find(params[:category]).children
    else
      @categories = []
    end
    respond_to do |format|
      format.html # show.html.erb
      format.atom { render :atom => @catalog }
    end
  end

  def bad_metadata
    params[:page] ||= 1
    @books = current_user.books.where("description IS NULL OR description='' OR category_id IS NULL OR lang NOT IN ('fr', 'en')").paginate(:page => params[:page], :per_page => 50)
    respond_to do |format|
      format.html { render "books/index"}
    end
  end

  def author
    @authors = @user.books.map(&:author).delete_if{|s| s.nil? || s == ''}.uniq.sort{ |a,b| a.downcase <=> b.downcase }

    respond_to do |format|
      format.html # show.html.erb
      format.atom { render :atom => @authors }
    end
  end

  def category
    if params[:category]
      @categories = Category.find(params[:category]).children.order('name')
    else
      @categories = Category.roots.order('name')
    end

    respond_to do |format|
      format.html # show.html.erb
      format.atom { render :atom => @categories }
    end
  end

  def serie
    @series = @user.books.map(&:serie).delete_if{|s| s.nil? || s == ''}.uniq.sort{ |a,b| a.downcase <=> b.downcase }
    logger.debug(@series.inspect)

    respond_to do |format|
      format.atom { render :atom => @series }
    end
  end

  def tags
    @tags = @user.books.map(&:tag_list).flatten.delete_if{|s| s.nil? || s == ''}.uniq.sort{ |a,b| a.downcase <=> b.downcase }

    respond_to do |format|
      format.html # show.html.erb
      format.atom { render :atom => @tags }
    end
  end

  def featured
    @books = @user.reading
    if @books.empty?
      @books = @user.books.limit(20).order('created_at desc')
    end

    respond_to do |format|
      format.atom { render :atom => @books }
    end
  end

  def reading_list
    @books = @user.reading.paginate(:page => params[:page], :per_page => 50)
    @categories = []

    respond_to do |format|
      format.html { render "books/index"}
      format.atom { render :template => "catalogs/all" }
    end
  end

  def share
    if params[:user_info]
      user = User.where("email = ? OR name = ?", params[:user_info], params[:user_info]).first
      if user
        c = CatalogShare.new
        c.user_id = current_user.id
        c.share_user_id = user.id
        c.save
      else
        flash[:notice] = "Can't find the user."
      end
    end
    if params[:id]
      c = CatalogShare.find(params[:id])
      if c.user_id == current_user.id
        c.destroy
        flash[:notice] = "The share is destroy."
      else
        raise ActionController::RoutingError.new('Not authorized')
      end
    end
    @shares = CatalogShare.where(:user_id => current_user.id)
    respond_to do |format|
      format.html { render "catalogs/share"}
    end
  end  

end

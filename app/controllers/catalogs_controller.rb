class CatalogsController < ApplicationController
  before_filter :authenticate_user!

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

  def author
    @authors = current_user.books.map(&:author).delete_if{|s| s.nil? || s == ''}.uniq.sort

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
    @series = current_user.books.map(&:serie).delete_if{|s| s.nil? || s == ''}.uniq
    logger.debug(@series.inspect)

    respond_to do |format|
      format.atom { render :atom => @series }
    end
  end

  def tags
    @tags = current_user.books.map(&:tag_list).flatten.delete_if{|s| s.nil? || s == ''}.uniq

    respond_to do |format|
      format.html # show.html.erb
      format.atom { render :atom => @tags }
    end
  end

  def featured
    @books = current_user.books.limit(20).order('created_at desc')

    respond_to do |format|
      format.atom { render :atom => @books }
    end
  end

end

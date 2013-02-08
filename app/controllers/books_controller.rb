require 'tempfile'

class BooksController < ApplicationController
  before_filter :authenticate_user!
  before_filter :check_owner, :except => [:index, :new, :create]
  protect_from_forgery :only => [:destroy]

  # GET /books
  # GET /books.xml
  def index
    search(30)
    respond_to do |format|
      format.html # index.html.erb
      format.atom  { render :xml => @books }
      format.json { rendder :json => @books }
      format.png { render :qrcode => url_for(:controller => 'catalogs', :action => 'index', :format => 'atom',:auth_token => current_user.authentication_token, :only_path => false, :protocol => "opds") }
    end
  end

  # GET /books/1
  # GET /books/1.atom
  def show
    @book = Book.find(params[:id])
    @read = ReadList.where(:user_id => current_user.id, :book_id => @book.id).first

    respond_to do |format|
      format.html # show.html.erb
      format.atom { render :atom => @book, :layout => false }
    end
  end

  # GET /books/new
  # GET /books/new.xml
  def new
    @book = Book.new
     @categories = Category.order(:names_depth_cache).map { |c| ["-" * c.depth + c.name,c.id] }

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @book }
    end
  end

  # GET /books/1/edit
  def edit
    @book = Book.find(params[:id])
     @categories = Category.order(:names_depth_cache).map { |c| ["-" * c.depth + c.name,c.id] }
  end

  # POST /books
  # POST /books.xml
  def create    
    epub = params[:file]
    logger.debug(epub.inspect)
    new_book = Book.new()
    new_book.epub = epub
    new_book.user_id = current_user.id
    new_book.import_metadata

    if new_book.title.blank? && new_book.epub
      new_book.title = File.basename(new_book.epub.url, '.epub')
    end
    
    new_book.save

    respond_to do |format|      
        format.html { render :nothing => true }
        format.xml  { render :xml => books_url, :status => :created, :location => books_url }
    end
  end

  # PUT /books/1
  # PUT /books/1.xml
  def update
    @book = Book.find(params[:id])
    epub = params[:book][:epub]
    if epub && epub.content_type == "application/epub+zip"
      @book.epub = epub
    end

    respond_to do |format|
      if @book.update_attributes(params[:book])
        format.html { redirect_to(@book, :notice => 'Book was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @book.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /books/1
  # DELETE /books/1.xml
  def destroy
    @book = Book.find(params[:id])
    @book.destroy

    respond_to do |format|
      format.html { redirect_to(books_url) }
      format.xml  { head :ok }
    end
  end

  def exist?
    Book.first.where(:md5 => params[:md5], :user_id => current_user.id)
    respond_to do |format|
      format.xml  { head :ok }
    end

  end

  def read_book
    @book = Book.find(params[:id])
    @book.read_book(current_user)
    redirect_to(@book, :notice => 'Book was successfully added to your reading list')
  end

  def unread_book
    @book = Book.find(params[:id])
    @book.unread_book(current_user)
    redirect_to(@book, :notice => 'Book was successfully delete from your reading list')
  end

  private

  def check_owner
    book = Book.find_by_id(:first, params[:id])
    if book && book.user_id == current_user.id
      return true
    end
    return false
  end

end

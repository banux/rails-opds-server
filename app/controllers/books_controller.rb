require 'tempfile'

class BooksController < ApplicationController
  before_filter :authenticate_user!, :except => :show
  before_filter :check_owner, :except => [:show, :index, :new, :create]
  protect_from_forgery :only => [:destroy]

  # GET /books
  # GET /books.xml
  def index
    @books = Book.includes(:catalogs).where(:user_id => current_user.id).page(params[:page]).order('author ASC')

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @books }
      format.json { rendder :json => @books }
    end
  end

  # GET /books/1
  # GET /books/1.xml
  def show
    @book = Book.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @book }
    end
  end

  # GET /books/new
  # GET /books/new.xml
  def new
    @book = Book.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @book }
    end
  end

  # GET /books/1/edit
  def edit
    @book = Book.find(params[:id])
  end

  # POST /books
  # POST /books.xml
  def create
    @book = Book.new(params[:book])
    @book.user_id = current_user.id
    @book.import_metadata

    if @book.title.nil? && @book.epub
      @book.title = File.basename(@book.epub.url, '.epub')
    end

    respond_to do |format|
      if @book.save
        if(params[:catalog])
          book_catalog = CatalogBook.create(:catalog_id => params[:catalog][:id], :book_id => @book.id)
        end
        format.html { redirect_to(@book, :notice => 'Book was successfully created.') }
        format.xml  { render :xml => @book, :status => :created, :location => @book }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @book.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /books/1
  # PUT /books/1.xml
  def update
    @book = Book.find(params[:id])

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

  private

  def check_owner
     book = Book.find(params[:id])
     if book.user_id == current_user.id
  return true
     end
    return false
  end

end

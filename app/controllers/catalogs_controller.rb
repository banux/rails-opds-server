class CatalogsController < ApplicationController
  before_filter :authenticate_user!, :except => :show
  before_filter :check_owner, :except => [:show, :index, :new, :create, :add_book, :del_book, :add_share, :del_share]
  protect_from_forgery :only => [:destroy]


  # GET /catalogs
  # GET /catalogs.xml
  def index
    @catalogs = Catalog.where(:user_id => current_user.id).all
    @shared_catalogs = SharedCatalog.includes(:catalog).where(:user_id => current_user.id).all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @catalogs }
    end
  end

  # GET /catalogs/1
  # GET /catalogs/1.xml
  def show
    @catalog = Catalog.find(params[:id])
    @books = @catalog.books.page(params[:page]).order('created_at DESC')
    if @catalog.status == 0
      if !current_user
        authenticate_user!
        #return render :text => "This catalog is not public", :status => :forbidden
      end
      if !(@catalog.shared_with?(current_user.id) || @catalog.user_id == current_user.id)
        authenticate_user!
        #return render :text => "This catalog is not public", :status => :forbidden
      end
    end

    respond_to do |format|
      format.html # show.html.erb
      format.xml  {
        if params[:authors]
          render :xml => @catalog.all_authors
        elsif params[:author]
          render :xml => @catalog.author(params[:author])
        else
          render :xml => @catalog.opds
        end
      }
    end
  end

  # GET /catalogs/new
  # GET /catalogs/new.xml
  def new
    @catalog = Catalog.new
    @catalog.status = 0

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @catalog }
    end
  end

  # GET /catalogs/1/edit
  def edit
    @catalog = Catalog.find(params[:id])
  end

  # POST /catalogs
  # POST /catalogs.xml
  def create
    @catalog = Catalog.new(params[:catalog])
    @catalog.user_id = current_user.id

    respond_to do |format|
      if @catalog.save
        format.html { redirect_to(@catalog, :notice => 'Catalog was successfully created.') }
        format.xml  { render :xml => @catalog, :status => :created, :location => @catalog }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @catalog.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /catalogs/1
  # PUT /catalogs/1.xml
  def update
    @catalog = Catalog.find(params[:id])

    respond_to do |format|
      if @catalog.update_attributes(params[:catalog])
        format.html { redirect_to(@catalog, :notice => 'Catalog was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @catalog.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /catalogs/1
  # DELETE /catalogs/1.xml
  def destroy
    @catalog = Catalog.find(params[:id])
    @catalog.destroy

    respond_to do |format|
      format.html { redirect_to(catalogs_url) }
      format.xml  { head :ok }
    end
  end

  def search
     

    respond_to do |format|
       format.xml {}
       format.html {}
    end
  end

  def add_book
    catalog = Catalog.find(params[:id])
    bc = CatalogBook.new    
    bc.catalog_id = catalog.id
    bc.book_id = params[:book_id]
    bc.save
    data = {'action' => 'ADD', 'title' => 'Remove from ' + catalog.title,
     'popover_title' => "Remove book from Catalogs", "popover_content" => "Remove this book from " + catalog.title + " Catalog."}
    render :json => data.to_json
  end

  def del_book
    catalog = Catalog.find(params[:id])
    bc = CatalogBook.find(:first, :conditions => ["book_id = ? and catalog_id = ?", params[:book_id], params[:id]])
    if bc
      bc.destroy
    end
    data = {'action' => 'DEL', 'title' => catalog.title,
     'popover_title' =>"Add book to Catalogs", "popover_content" => "Add this book to " + catalog.title + " Catalog."}
    render :json => data.to_json
  end

  def add_share
    user = User.find_by_email(params[:email])
    catalog = Catalog.find(params[:id])
    if user && catalog
      share = SharedCatalog.create(:catalog_id => params[:id], :user_id => user.id)
      return render :json => [user.name, del_share_catalog_path(catalog) + '?share_id=' + share.id.to_s].to_json
    else
      return :status => :not_founded
    end    
  end

  def del_share
    share = SharedCatalog.find(params[:share_id])
    share.destroy
    render :text => "DEL"
  end

private

  def check_owner
     catalog = Catalog.find(params[:id])
     if catalog.user_id == current_user.id
	return true
     end
    return false
  end

end

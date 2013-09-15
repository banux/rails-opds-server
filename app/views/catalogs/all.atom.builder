xml.title  "Catalogs of " + @user.name + ' All Entry'
xml.link(:type => "application/atom+xml;profile=opds-catalog;kind=acquisition", :rel => "start", :href => "/catalogs.atom")
xml.link(:type => "application/atom+xml;profile=opds-catalog;kind=acquisition", :rel => "self", :href => catalogs_all_path(:format => "atom", :user_id => @user.id))
xml.updated  Time.now.xmlschema
if params[:page].nil? || params[:page] == 1
	@categories.each do |category|
		xml.entry do |c|
			c.title category.name
			c.link(:type => "application/atom+xml;profile=opds-catalog;kind=acquisition", :rel => "http://opds-spec.org/subsection", :href => catalogs_all_path(:format => "atom", :auth_token => params[:auth_token]) + '?category=' + category.id.to_s)
			c.id @user.id.to_s + '_category_' + category.id.to_s
			c.updated Time.now.utc.xmlschema
			c.summary "Category : " + category.name
		end
	end
end
@books.each do |book|
	xml.entry do |f|
	   render partial: 'books/book', :locals => {feed: f, book: book}
	end
end

if @books.current_page < @books.total_pages
	xml.link(:type => "application/atom+xml;profile=opds-catalog;kind=acquisition", :rel => "next", :href => url_for(params.merge(:page => @books.current_page + 1)), :title => 'Next' )
end
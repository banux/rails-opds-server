xml.title  "Search for " + params[:q]
xml.link(:type => "application/atom+xml;profile=opds-catalog;kind=acquisition", :rel => "start", :href => "/catalogs.atom")
xml.link(:type => "application/atom+xml;profile=opds-catalog;kind=acquisition", :rel => "self", :href => "/catalogs.atom")
xml.updated  Time.now.utc.xmlschema
xml.author do |author|
  author.name current_user.name
end
@books.each do |book|
	xml.entry do |f|
		render partial: 'books/book', :locals => {feed: f, book: book}
	end
end
if @books.current_page < @books.total_pages
			xml.link(:type => "application/atom+xml;profile=opds-catalog;kind=acquisition", :rel => "next", :href => url_for(params.merge(:page => @books.current_page + 1)), :title => 'Next' )
end
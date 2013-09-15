xml.title  "Featured Catalogs of " + @user.name
xml.link(:type => "application/atom+xml;profile=opds-catalog;kind=acquisition", :rel => "start", :href => "/catalogs.atom")
xml.link(:type => "application/atom+xml;profile=opds-catalog;kind=acquisition", :rel => "self", :href => catalogs_featured_path(:format => "atom"))
xml.updated  Time.now.xmlschema
@books.each do |book|
  xml.entry do |f|
	 render partial: 'books/book', :locals => {feed: f, book: book}
  end
end
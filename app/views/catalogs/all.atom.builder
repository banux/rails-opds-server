xml.id current_user.id
xml.title  "Catalogs of " + current_user.name + ' All Entry'
xml.link(:type => "application/atom+xml;profile=opds-catalog;kind=acquisition", :rel => "start", :href => "/catalogs.atom")
xml.link(:type => "application/atom+xml;profile=opds-catalog;kind=acquisition", :rel => "self", :href => catalogs_all_path(:format => "atom"))
xml.updated  Time.now.xmlschema
if params[:page].nil? || params[:page] == 1
	@categories.each do |category|
		xml.entry do |c|
			c.title category.name
			c.link(:type => "application/atom+xml;profile=opds-catalog;kind=acquisition", :rel => "http://opds-spec.org/subsection", :href => catalogs_all_path(:format => "atom", :auth_token => params[:auth_token]) + '?category=' + category.id.to_s)
			c.id current_user.id.to_s + '_category_' + category.id.to_s
			c.updated Time.now.utc.xmlschema
			c.summary "Category : " + category.name
		end			
	end
end
@books.each do |book|
	xml.entry do |f|
	   f.title  book.title
	   if !book.author.blank?
		    f.author do
		    	f.name book.author
		    end
	  	end
      f.id  "urn:uuid:" + book.uuid
      f.updated  book.updated_at.xmlschema
      f.summary  book.description
      f.tag!('dc:language',  book.lang)
		  f.category(:label => book.category.name, :term => book.category.name) unless book.category.nil?
      if book.cover
	    f.link(:href => book.cover.medium.url, :rel => "http://opds-spec.org/image", :type => book.cover_type)
	    f.link(:href => book.cover.thumb.url, :rel => "http://opds-spec.org/image/thumbnail", :type => book.cover_type)
  		  end
      f.link(:href => book_path(book, :format => "atom", :auth_token => params[:auth_token]), :rel => "alternate",
        :type => "http://opds-spec.org/type=entry;profile=opds-catalog",
        :title => book.title)
      if book.epub
			  f.link(:href => book.epub.url,
    			:rel => "http://opds-spec.org/acquisition", 
    			:type => "application/epub+zip") 
			end
  	end
	end
	if @books.current_page < @books.total_pages
			xml.link(:type => "application/atom+xml;profile=opds-catalog;kind=acquisition", :rel => "next", :href => url_for(params.merge(:page => @books.current_page + 1)), :title => 'Next' )
end
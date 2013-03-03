xml.id @user.id
xml.title  "Featured Catalogs of " + @user.name
xml.link(:type => "application/atom+xml;profile=opds-catalog;kind=acquisition", :rel => "start", :href => "/catalogs.atom")
xml.link(:type => "application/atom+xml;profile=opds-catalog;kind=acquisition", :rel => "self", :href => catalogs_featured_path(:format => "atom"))
xml.updated  Time.now.xmlschema
@books.each do |book|
	xml.entry do |f|
	   f.title  book.title
      f.id  "urn:uuid:" + book.uuid
      f.published book.created_at.xmlschema
      f.updated  book.updated_at.xmlschema
      f.summary  book.description
      f.tag!('dc:language',  book.lang)
      f.category(:label => book.category.name, :term => book.category.name) unless book.category.nil?
      if book.author
      	f.author do |aut|
      		aut.name book.author
      		aut.uri catalogs_all_path(:format => "atom") + '?author=' + u(book.author)
      	end
      end
      if book.cover
	    f.link(:href => book.cover.medium.url, :rel => "http://opds-spec.org/image", :type => book.cover_type)
	    f.link(:href => book.cover.thumb.url, :rel => "http://opds-spec.org/image/thumbnail", :type => book.cover_type)
  		  end
      f.link(:href => book_path(book, :format => "atom"), :rel => "alternate",
        :type => "http://opds-spec.org/type=entry;profile=opds-catalog",
        :title => book.title)
      if book.epub
			  f.link(:href => book.epub.url,
    			:rel => "http://opds-spec.org/acquisition", 
    			:type => "application/epub+zip") 
			end
  	end
	end
	
	xml.link(:type => "application/atom+xml;profile=opds-catalog;kind=acquisition", :rel => "self", :href => catalogs_all_path(:format => "atom"))
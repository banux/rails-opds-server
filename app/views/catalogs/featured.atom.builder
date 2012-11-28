  xml.instruct!(:xml, :version=>"1.0", :encoding => "UTF-8")
	xml.feed({'xmlns:dcterms' => 'http://purl.org/dc/terms/', "xmlns:thr" => "http://purl.org/syndication/thread/1.0", "xmlns:app" => "http://www.w3.org/2007/app", "xmlns:opensearch" => "http://a9.com/-/spec/opensearch/1.1/", "xmlns" => "http://www.w3.org/2005/Atom", "xmlns:opds" => "http://opds-spec.org/2010/catalog", 'xmlns:xsi' => "http://www.w3.org/2001/XMLSchema-instance", "xml:lang" => 'fr'}) do |feed|
		feed.id current_user.id
	  feed.title  "Featured Catalogs of " + current_user.name
		feed.link(:type => "application/atom+xml;profile=opds-catalog;kind=acquisition", :rel => "start", :href => "/catalogs.atom")
		feed.link(:type => "application/atom+xml;profile=opds-catalog;kind=acquisition", :rel => "self", :href => catalogs_featured_path(:format => "atom"))
		feed.updated  Time.now.xmlschema
		@books.each do |book|
			feed.entry do |f|
			   f.title  book.title
		      f.id  "urn:uuid:" + book.uuid
		      f.updated  book.updated_at.xmlschema
		      f.summary  book.description
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
    	
    	feed.link(:type => "application/atom+xml;profile=opds-catalog;kind=acquisition", :rel => "self", :href => catalogs_all_path(:format => "atom"))
	end
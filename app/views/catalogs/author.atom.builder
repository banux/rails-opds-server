  xml.instruct!(:xml, :version=>"1.0", :encoding => "UTF-8")
	xml.feed({'xmlns:dc' => 'http://purl.org/dc/terms/', "xmlns:thr" => "http://purl.org/syndication/thread/1.0", "xmlns:app" => "http://www.w3.org/2007/app", "xmlns:opensearch" => "http://a9.com/-/spec/opensearch/1.1/", "xmlns" => "http://www.w3.org/2005/Atom", "xmlns:opds" => "http://opds-spec.org/2010/catalog", 'xmlns:xsi' => "http://www.w3.org/2001/XMLSchema-instance", "xml:lang" => 'fr'}) do |feed|
		feed.id current_user.id
	  feed.title  "Catalogs of " + current_user.name
		feed.link(:type => "application/atom+xml;profile=opds-catalog;kind=acquisition", :rel => "start", :href => "/catalogs.atom")
		feed.link(:type => "application/atom+xml;profile=opds-catalog;kind=acquisition", :rel => "self", :href => catalogs_author_path(:format => "atom"))
		feed.updated  Time.now.xmlschema
		@authors.each do |author|
			feed.entry do |c|
				c.title author
	  			c.link(:type => "application/atom+xml;profile=opds-catalog;kind=acquisition", :rel => "http://opds-spec.org/subsection", :href => catalogs_all_path(:format => "atom") + '?author=' + u(author))
	  			c.id current_user.id.to_s + '_author_' + u(author)
	  			c.updated Time.now.utc.xmlschema
	  			c.summary "From : " + author
	  		end			
    	end
	end
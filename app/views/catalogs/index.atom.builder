  xml.instruct!(:xml, :version=>"1.0", :encoding => "UTF-8")
	xml.feed({'xmlns:dc' => 'http://purl.org/dc/terms/', "xmlns:thr" => "http://purl.org/syndication/thread/1.0", "xmlns:app" => "http://www.w3.org/2007/app", "xmlns:opensearch" => "http://a9.com/-/spec/opensearch/1.1/", "xmlns" => "http://www.w3.org/2005/Atom", "xmlns:opds" => "http://opds-spec.org/2010/catalog", 'xmlns:xsi' => "http://www.w3.org/2001/XMLSchema-instance", "xml:lang" => 'fr'}) do |feed|
		feed.id current_user.id
  		feed.title  "Catalogs of " + current_user.name
		feed.link(:type => "application/atom+xml;profile=opds-catalog;kind=acquisition", :rel => "start", :href => "/catalogs.atom")
		feed.link(:type => "application/atom+xml;profile=opds-catalog;kind=acquisition", :rel => "self", :href => "/catalogs.atom")
		feed.link(:type => "application/atom+xml;profile=opds-catalog;kind=acquisition", :rel => "http://opds-spec.org/featured", :href => catalogs_featured_path(:format => "atom"), :title => "Featured")
		feed.link(:type => "application/opensearchdescription+xml", :rel => "search", :href => "/search.xml")
		feed.updated Time.now.utc.xmlschema
		feed.entry do |c|
			c.title 'All entry'
	  		c.link(:type => "application/atom+xml;profile=opds-catalog;kind=acquisition", :rel => "http://opds-spec.org/subsection", :href => catalogs_all_path(:format => "atom"))
	  		c.id current_user.id.to_s + '_all'
	  		c.updated Time.now.utc.xmlschema
	  		c.content "All"
	  	end

		feed.entry do |c|
			c.title 'by Serie'
	  		c.link(:type => "application/atom+xml;profile=opds-catalog;kind=acquisition", :rel => "http://opds-spec.org/subsection", :href => catalogs_serie_path(:format => "atom"))
	  		c.id current_user.id.to_s + '_author'
	  		c.updated Time.now.utc.xmlschema
	  		c.summary "by Serie"
	  	end

		feed.entry do |c|
			c.title 'by Category'
	  		c.link(:type => "application/atom+xml;profile=opds-catalog;kind=acquisition", :rel => "http://opds-spec.org/subsection", :href => catalogs_category_path(:format => "atom"))
	  		c.id current_user.id.to_s + '_category'
	  		c.updated Time.now.utc.xmlschema
	  		c.summary "by Category"
	  	end

	  	feed.entry do |c|
			c.title 'by Author'
	  		c.link(:type => "application/atom+xml;profile=opds-catalog;kind=acquisition", :rel => "http://opds-spec.org/subsection", :href => catalogs_author_path(:format => "atom"))
	  		c.id current_user.id.to_s + '_author'
	  		c.updated Time.now.utc.xmlschema
	  		c.summary "by Author"
	  	end

	    feed.entry do |c|
			c.title 'by Tag'
	  		c.link(:type => "application/atom+xml;profile=opds-catalog;kind=acquisition", :rel => "http://opds-spec.org/subsection", :href => catalogs_tags_path(:format => "atom"))
	  		c.id current_user.id.to_s + '_tag'
	  		c.updated Time.now.utc.xmlschema
	  		c.summary "by Tag"
	  	end	  	
  end
  xml.instruct!(:xml, :version=>"1.0", :encoding => "UTF-8")
	xml.feed({'xmlns:dc' => 'http://purl.org/dc/terms/', "xmlns:thr" => "http://purl.org/syndication/thread/1.0", "xmlns:app" => "http://www.w3.org/2007/app", "xmlns:opensearch" => "http://a9.com/-/spec/opensearch/1.1/", "xmlns" => "http://www.w3.org/2005/Atom", "xmlns:opds" => "http://opds-spec.org/2010/catalog", 'xmlns:xsi' => "http://www.w3.org/2001/XMLSchema-instance", "xml:lang" => 'fr'}) do |feed|
		feed.id @catalog.uuid
	  feed.title  @catalog.title + " Catalogs of " + @user.name
		feed.link(:type => "application/atom+xml;profile=opds-catalog;kind=acquisition", :rel => "start", :href => "/catalogs.atom")
		feed.link(:type => "application/atom+xml;profile=opds-catalog;kind=acquisition", :rel => "self", :href => catalog_path(@catalog, :format => "atom"))
		feed.link(:type => "application/atom+xml;profile=opds-catalog;kind=acquisition", :rel => "http://opds-spec.org/featured", :href => featured_catalog_path(@catalog, :format => "atom"), :title => "Featured")
		feed.link(:type => "application/opensearchdescription+xml", :rel => "search", :href => "/search.xml")
		feed.updated  @catalog.updated_at
		feed.entry do |c|
			c.title 'All entry'
	  		c.link(:type => "application/atom+xml;profile=opds-catalog;kind=acquisition", :rel => "http://opds-spec.org/subsection", :href => all_catalog_path(@catalog, :format => "atom"))
	  		c.id @catalog.uuid + '_all'
	  		c.updated @catalog.updated_at.utc.xmlschema
	  		c.content "All"
	  	end

		feed.entry do |c|
			c.title 'by Serie'
	  		c.link(:type => "application/atom+xml;profile=opds-catalog;kind=acquisition", :rel => "http://opds-spec.org/subsection", :href => serie_catalog_path(@catalog, :format => "atom"))
	  		c.id @catalog.uuid + '_author'
	  		c.updated @catalog.updated_at.utc.xmlschema
	  		c.summary "by Serie"
	  	end

	  	feed.entry do |c|
			c.title 'by Author'
	  		c.link(:type => "application/atom+xml;profile=opds-catalog;kind=acquisition", :rel => "http://opds-spec.org/subsection", :href => author_catalog_path(@catalog, :format => "atom"))
	  		c.id @catalog.uuid + '_author'
	  		c.updated @catalog.updated_at.utc.xmlschema
	  		c.summary "by Author"
	  	end

	    feed.entry do |c|
			c.title 'by Tag'
	  		c.link(:type => "application/atom+xml;profile=opds-catalog;kind=acquisition", :rel => "http://opds-spec.org/subsection", :href => tags_catalog_path(@catalog, :format => "atom"))
	  		c.id @catalog.uuid + '_tag'
	  		c.updated @catalog.updated_at.utc.xmlschema
	  		c.summary "by Tag"
	  	end
  end
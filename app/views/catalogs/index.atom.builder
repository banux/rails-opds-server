xml.id current_user.id
xml.title  "Catalogs of " + current_user.name
xml.link(:type => "application/atom+xml;profile=opds-catalog;kind=acquisition", :rel => "start", :href => "/catalogs.atom")
xml.link(:type => "application/atom+xml;profile=opds-catalog;kind=acquisition", :rel => "self", :href => "/catalogs.atom")
xml.link(:type => "application/atom+xml;profile=opds-catalog;kind=acquisition", :rel => "http://opds-spec.org/featured", :href => catalogs_featured_path(:format => "atom"), :title => "Featured")
xml.link(:type => "application/opensearchdescription+xml", :rel => "search", :href => "/search.xml")
xml.updated Time.now.utc.xmlschema

xml.entry do |c|
	c.title 'My reading list'
	c.link(:type => "application/atom+xml;profile=opds-catalog;kind=acquisition", :rel => "http://opds-spec.org/subsection", :href => catalogs_reading_list_path(:format => "atom", :auth_token => params[:auth_token]))
	c.id current_user.id.to_s + '_reading'
	c.updated Time.now.utc.xmlschema
	c.summary "My reading list"
end

xml.entry do |c|
	c.title 'All entry'
	c.link(:type => "application/atom+xml;profile=opds-catalog;kind=acquisition", :rel => "http://opds-spec.org/subsection", :href => catalogs_all_path(:format => "atom", :auth_token => params[:auth_token]))
	c.id current_user.id.to_s + '_all'
	c.updated Time.now.utc.xmlschema
	c.content "All"
end

xml.entry do |c|
	c.title 'by Serie'
	c.link(:type => "application/atom+xml;profile=opds-catalog;kind=acquisition", :rel => "http://opds-spec.org/subsection", :href => catalogs_serie_path(:format => "atom", :auth_token => params[:auth_token]))
	c.id current_user.id.to_s + '_author'
	c.updated Time.now.utc.xmlschema
	c.summary "by Serie"
end

xml.entry do |c|
	c.title 'by Category'
	c.link(:type => "application/atom+xml;profile=opds-catalog;kind=acquisition", :rel => "http://opds-spec.org/subsection", :href => catalogs_category_path(:format => "atom", :auth_token => params[:auth_token]))
	c.id current_user.id.to_s + '_category'
	c.updated Time.now.utc.xmlschema
	c.summary "by Category"
end

xml.entry do |c|
	c.title 'by Author'
	c.link(:type => "application/atom+xml;profile=opds-catalog;kind=acquisition", :rel => "http://opds-spec.org/subsection", :href => catalogs_author_path(:format => "atom", :auth_token => params[:auth_token]))
	c.id current_user.id.to_s + '_author'
	c.updated Time.now.utc.xmlschema
	c.summary "by Author"
end

 xml.entry do |c|
	c.title 'by Tag'
	c.link(:type => "application/atom+xml;profile=opds-catalog;kind=acquisition", :rel => "http://opds-spec.org/subsection", :href => catalogs_tags_path(:format => "atom", :auth_token => params[:auth_token]))
	c.id current_user.id.to_s + '_tag'
	c.updated Time.now.utc.xmlschema
	c.summary "by Tag"
end
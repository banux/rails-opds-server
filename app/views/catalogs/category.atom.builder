xml.id current_user.id
xml.title  "Catalogs of " + current_user.name
xml.link(:type => "application/atom+xml;profile=opds-catalog;kind=acquisition", :rel => "start", :href => "/catalogs.atom")
xml.link(:type => "application/atom+xml;profile=opds-catalog;kind=acquisition", :rel => "self", :href => catalogs_author_path(:format => "atom"))
xml.updated  Time.now.xmlschema
@categories.each do |category|
	xml.entry do |c|
		c.title category.name
		c.link(:type => "application/atom+xml;profile=opds-catalog;kind=acquisition", :rel => "http://opds-spec.org/subsection", :href => catalogs_all_path(:format => "atom", :auth_token => params[:auth_token], :category => category.id))
		c.id current_user.id.to_s + '_category_' + category.id.to_s
		c.updated Time.now.utc.xmlschema
		c.summary "Category : " + category.name
	end			
end
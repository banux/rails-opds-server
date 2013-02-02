xml.id current_user.id
xml.title  "Tags Catalogs of " + current_user.name
xml.link(:type => "application/atom+xml;profile=opds-catalog;kind=acquisition", :rel => "start", :href => "/catalogs.atom")
xml.link(:type => "application/atom+xml;profile=opds-catalog;kind=acquisition", :rel => "self", :href => catalogs_tags_path(:format => "atom"))
xml.updated  Time.now.xmlschema
@tags.each do |tag|
	xml.entry do |c|
		c.title tag
		c.link(:type => "application/atom+xml;profile=opds-catalog;kind=acquisition", :rel => "http://opds-spec.org/subsection", :href => catalogs_all_path(:format => "atom", :auth_token => params[:auth_token], :tag => u(tag)))
		c.id current_user.id.to_s + '_author_' + u(tag)
		c.updated Time.now.utc.xmlschema
		c.summary "By : " + tag
	end			
end
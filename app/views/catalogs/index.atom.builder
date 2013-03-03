xml.id @user.id
xml.title  "Catalogs of " + @user.name
xml.link(:type => "application/atom+xml;profile=opds-catalog;kind=acquisition", :rel => "start", :href => "/catalogs.atom")
if current_user.id == @user.id
	xml.link(:type => "application/atom+xml;profile=opds-catalog;kind=acquisition", :rel => "self", :href => "/catalogs.atom")
else	
	xml.link(:type => "application/atom+xml;profile=opds-catalog;kind=acquisition", :rel => "self", :href => "/catalogs.atom?user_id=#{@user.id}")
end
xml.link(:type => "application/atom+xml;profile=opds-catalog;kind=acquisition", :rel => "http://opds-spec.org/featured", :href => catalogs_featured_path(:format => "atom", :user_id => @user.id), :title => "Featured")
xml.link(:type => "application/opensearchdescription+xml", :rel => "search", :href => "/search.xml")
xml.updated Time.now.utc.xmlschema

if current_user.id == @user.id
	xml.entry do |c|
		c.title 'My reading list'
		c.link(:type => "application/atom+xml;profile=opds-catalog;kind=acquisition", :rel => "http://opds-spec.org/subsection", :href => catalogs_reading_list_path(:format => "atom", :auth_token => params[:auth_token]))
		c.id current_user.id.to_s + '_reading'
		c.updated Time.now.utc.xmlschema
		c.summary "My reading list"
	end
end

xml.entry do |c|
	c.title 'All entry'
	c.link(:type => "application/atom+xml;profile=opds-catalog;kind=acquisition", :rel => "http://opds-spec.org/subsection", :href => catalogs_all_path(:format => "atom", :auth_token => params[:auth_token], :user_id => @user.id))
	c.id current_user.id.to_s + '_all'
	c.updated Time.now.utc.xmlschema
	c.content "All"
end

xml.entry do |c|
	c.title 'by Serie'
	c.link(:type => "application/atom+xml;profile=opds-catalog;kind=acquisition", :rel => "http://opds-spec.org/subsection", :href => catalogs_serie_path(:format => "atom", :auth_token => params[:auth_token], :user_id => @user.id))
	c.id current_user.id.to_s + '_author'
	c.updated Time.now.utc.xmlschema
	c.summary "by Serie"
end

xml.entry do |c|
	c.title 'by Category'
	c.link(:type => "application/atom+xml;profile=opds-catalog;kind=acquisition", :rel => "http://opds-spec.org/subsection", :href => catalogs_category_path(:format => "atom", :auth_token => params[:auth_token], :user_id => @user.id))
	c.id current_user.id.to_s + '_category'
	c.updated Time.now.utc.xmlschema
	c.summary "by Category"
end

xml.entry do |c|
	c.title 'by Author'
	c.link(:type => "application/atom+xml;profile=opds-catalog;kind=acquisition", :rel => "http://opds-spec.org/subsection", :href => catalogs_author_path(:format => "atom", :auth_token => params[:auth_token], :user_id => @user.id))
	c.id current_user.id.to_s + '_author'
	c.updated Time.now.utc.xmlschema
	c.summary "by Author"
end

xml.entry do |c|
	c.title 'by Tag'
	c.link(:type => "application/atom+xml;profile=opds-catalog;kind=acquisition", :rel => "http://opds-spec.org/subsection", :href => catalogs_tags_path(:format => "atom", :auth_token => params[:auth_token], :user_id => @user.id))
	c.id current_user.id.to_s + '_tag'
	c.updated Time.now.utc.xmlschema
	c.summary "by Tag"
end

if current_user.id == @user.id
	current_user.catalogs.each do |share|
		xml.entry do |c|
			c.title "#{share.name} Catalog"
			c.link(:type => "application/atom+xml;profile=opds-catalog;kind=acquisition", :rel => "http://opds-spec.org/subsection", :href => catalogs_index_path(:format => "atom", :user_id => share.id, :auth_token => params[:auth_token]))
			c.id current_user.id.to_s + '_share_' + share.id.to_s
			c.updated Time.now.utc.xmlschema
			c.summary "#{share.name} Catalog"
		end
	end
end
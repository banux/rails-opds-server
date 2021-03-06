xml.title  "Catalogs of " + @user.name
xml.link(:type => "application/atom+xml;profile=opds-catalog;kind=acquisition", :rel => "start", :href => "/catalogs.atom")
xml.link(:type => "application/atom+xml;profile=opds-catalog;kind=acquisition", :rel => "self", :href => catalogs_author_path(:format => "atom"))
xml.updated  Time.now.xmlschema
@authors.each do |author|
	xml.entry do |c|
		c.title author
		c.link(:type => "application/atom+xml;profile=opds-catalog;kind=acquisition", :rel => "http://opds-spec.org/subsection", :href => catalogs_all_path(:format => "atom", :author => author))
		c.id @user.id.to_s + '_author_' + u(author)
		c.updated Time.now.utc.xmlschema
		c.summary "From : " + author
	end
end
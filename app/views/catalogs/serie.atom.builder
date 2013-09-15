xml.title  "Serie Catalogs of " + @user.name
xml.link(:type => "application/atom+xml;profile=opds-catalog;kind=acquisition", :rel => "start", :href => "/catalogs.atom")
xml.link(:type => "application/atom+xml;profile=opds-catalog;kind=acquisition", :rel => "self", :href => catalogs_serie_path(:format => "atom"))
xml.updated  Time.now.xmlschema
@series.each do |serie|
	xml.entry do |c|
		c.title serie
		c.link(:type => "application/atom+xml;profile=opds-catalog;kind=acquisition", :rel => "http://opds-spec.org/subsection", :href => catalogs_all_path(:format => "atom", :auth_token => params[:auth_token], :serie => serie))
		c.id @user.id.to_s + '_serie_' + u(serie)
		c.updated Time.now.utc.xmlschema
		c.summary "Serie : " + serie
	end
end
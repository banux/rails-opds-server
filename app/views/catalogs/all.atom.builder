xml.title  "Catalogs of " + @user.name + ' All Entry'
xml.link(:type => "application/atom+xml;profile=opds-catalog;kind=acquisition", :rel => "start", :href => "/catalogs.atom")
xml.link(:type => "application/atom+xml;profile=opds-catalog;kind=acquisition", :rel => "self", :href => catalogs_all_path(:format => "atom", :user_id => @user.id))
xml.updated  Time.now.xmlschema

@categories.each do |category|
	xml.link(:title => category.name, :href => catalogs_all_path(:format => "atom", :auth_token => params[:auth_token], :category => category.id), :rel => "http://opds-spec.org/facet", 'opds:facetGroup' => "Category", :type => "application/atom+xml;profile=opds-catalog;kind=acquisition")
end

unless @facets.nil?
	@facets['lang']['terms'].each do |f|
		f_hash = {:title => f['term'],
				:href => catalogs_all_path(:format => "atom", :auth_token => params[:auth_token], :lang => f['term']),
				:rel => "http://opds-spec.org/facet",
				'opds:facetGroup' => "Language",
				:type => "application/atom+xml;profile=opds-catalog;kind=acquisition"}
		if params[:lang] && params[:lang] == f['term']
			f_hash.update('opds:activeFacet' => "true")
		end
		xml.link f_hash
	end

	@facets['author']['terms'].each do |f|
		f_hash = {:title => f['term'],
				:href => catalogs_all_path(:format => "atom", :auth_token => params[:auth_token], :author => f['term']),
				:rel => "http://opds-spec.org/facet",
				'opds:facetGroup' => "Author",
				:type => "application/atom+xml;profile=opds-catalog;kind=acquisition"}
		if params[:author] && params[:author] == f['term']
			f_hash.update('opds:activeFacet' => "true")
		end
		xml.link f_hash
	end

	@facets['serie']['terms'].each do |f|
		f_hash = {:title => f['term'],
				:href => catalogs_all_path(:format => "atom", :auth_token => params[:auth_token], :serie => f['term']),
				:rel => "http://opds-spec.org/facet",
				'opds:facetGroup' => "Serie",
				:type => "application/atom+xml;profile=opds-catalog;kind=acquisition"}
		if params[:serie] && params[:serie] == f['term']
			f_hash.update('opds:activeFacet' => "true")
		end
		xml.link f_hash
	end

end


@books.each do |book|
	xml.entry do |f|
	   render partial: 'books/book', :locals => {feed: f, book: book}
	end
end

if @books.current_page < @books.total_pages
	xml.link(:type => "application/atom+xml;profile=opds-catalog;kind=acquisition", :rel => "next", :href => url_for(params.merge(:page => @books.current_page + 1)), :title => 'Next' )
end
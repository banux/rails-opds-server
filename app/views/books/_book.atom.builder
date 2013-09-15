feed.title  book.title
if !book.author.blank?
  feed.author do
  	feed.name book.author
  end
end
feed.id  "urn:uuid:" + book.uuid
feed.updated  book.updated_at.xmlschema
feed.summary  book.description
feed.tag!('dc:language',  book.lang)
feed.category(:label => book.category.name, :term => book.category.name) unless book.category.nil?
if book.cover
feed.link(:href => book.cover.medium.url, :rel => "http://opds-spec.org/image", :type => book.cover_type)
feed.link(:href => book.cover.thumb.url, :rel => "http://opds-spec.org/image/thumbnail", :type => book.cover_type)
  end
feed.link(:href => book_path(book, :format => "atom", :auth_token => params[:auth_token]),
  :rel => "alternate",
  :type => "application/atom+xml;type=entry;profile=opds-catalog",
  :title => book.title)
if book.epub
  feed.link(:href => book.epub.url,
		:rel => "http://opds-spec.org/acquisition",
		:type => "application/epub+zip")
end
xml.id  "urn:uuid:" + @book.uuid
xml.title  @book.title
xml.link(:type => "application/atom+xml;profile=opds-catalog;kind=acquisition", :rel => "start", :href => "/catalogs.atom")
xml.link(:type => "application/atom+xml;profile=opds-catalog;kind=acquisition", :rel => "root", :href => "/catalogs.atom")
xml.published @book.created_at.xmlschema
xml.updated  @book.updated_at.xmlschema
xml.content  @book.description
xml.tag!('dc:language',  @book.lang)
xml.category(:label => @book.category.name, :term => @book.category.name) unless @book.category.nil?
if @book.author
 xml.author do |aut|
  aut.name @book.author
  aut.uri catalogs_all_path(:format => "atom") + '?author=' + u(@book.author)
 end
end
if @book.epub
  xml.link(:href => "#{request.protocol}#{request.host_with_port}#{@book.epub.url}",
    :rel => "http://opds-spec.org/acquisition", 
    :type => "application/epub+zip") 
end
 if @book.cover
  xml.link(:href => @book.cover.medium.url, :rel => "http://opds-spec.org/image", :type => @book.cover_type)
  xml.link(:href => @book.cover.thumb.url, :rel => "http://opds-spec.org/image/thumbnail", :type => @book.cover_type)
 end
 if @book.author
  xml.link(:type => "application/atom+xml;profile=opds-catalog;kind=acquisition", :rel => "related", :href => catalogs_all_path(:format => "atom") + '?author=' + u(@book.author), :title => @book.author)
 end
 if @book.serie
  xml.link(:type => "application/atom+xml;profile=opds-catalog;kind=acquisition", :rel => "related", :href => catalogs_all_path(:format => "atom") + '?serie=' + u(@book.serie), :title => @book.serie)
 end
  xml.instruct!(:xml, :version=>"1.0", :encoding => "UTF-8")
  xml.entry({'xmlns:dc' => 'http://purl.org/dc/terms/', "xmlns:thr" => "http://purl.org/syndication/thread/1.0", "xmlns:app" => "http://www.w3.org/2007/app", "xmlns:opensearch" => "http://a9.com/-/spec/opensearch/1.1/", "xmlns" => "http://www.w3.org/2005/Atom", "xmlns:opds" => "http://opds-spec.org/2010/catalog", 'xmlns:xsi' => "http://www.w3.org/2001/XMLSchema-instance", "xml:lang" => 'fr'}) do |feed|
    feed.id  "urn:uuid:" + @book.uuid
    feed.title  @book.title
    feed.link(:type => "application/atom+xml;profile=opds-catalog;kind=acquisition", :rel => "start", :href => "/catalogs.atom")
    feed.link(:type => "application/atom+xml;profile=opds-catalog;kind=acquisition", :rel => "root", :href => "/catalogs.atom")
    feed.published @book.created_at.xmlschema
    feed.updated  @book.updated_at.xmlschema
    feed.content  @book.description
    feed.tag!('dc:language',  @book.lang)
    feed.category(:label => @book.category.name, :term => @book.category.name) unless @book.category.nil?
    if @book.author
     feed.author do |aut|
      aut.name @book.author
      aut.uri catalogs_all_path(:format => "atom") + '?author=' + u(@book.author)
     end
    end
    if @book.epub
      feed.link(:href => "#{request.protocol}#{request.host_with_port}#{@book.epub.url}",
        :rel => "http://opds-spec.org/acquisition", 
        :type => "application/epub+zip") 
    end
     if @book.cover
      feed.link(:href => @book.cover.medium.url, :rel => "http://opds-spec.org/image", :type => @book.cover_type)
      feed.link(:href => @book.cover.thumb.url, :rel => "http://opds-spec.org/image/thumbnail", :type => @book.cover_type)
     end
     if @book.author
      feed.link(:type => "application/atom+xml;profile=opds-catalog;kind=acquisition", :rel => "related", :href => catalogs_all_path(:format => "atom") + '?author=' + u(@book.author), :title => @book.author)
     end
     if @book.serie
      feed.link(:type => "application/atom+xml;profile=opds-catalog;kind=acquisition", :rel => "related", :href => catalogs_all_path(:format => "atom") + '?serie=' + u(@book.serie), :title => @book.serie)
     end
   end
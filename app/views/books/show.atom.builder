xml.instruct!(:xml, :version=>"1.0", :encoding => "UTF-8")
xml.tag!("entry", {"xmlns".to_sym => "http://www.w3.org/2005/Atom", "xmlns:thr".to_sym => "http://purl.org/syndication/thread/1.0", "xmlns:dcterms".to_sym => "http://purl.org/dc/terms/", "xmlns:opds" => "http://opds-spec.org/2010/catalog"}, "xmlns:xsi".to_sym => "http://www.w3.org/2001/XMLSchema-instance") do
  xml.id  "urn:uuid:" + @book.uuid
  xml.title  @book.title
  xml.published @book.created_at.xmlschema
  xml.updated  @book.updated_at.xmlschema
  xml.content  @book.description
  xml.tag!('dcterms:language',  @book.lang)
  xml.category(:label => @book.category.name, :term => @book.category.name) unless @book.category.nil?
  if @book.author
   xml.author do |aut|
    aut.name @book.author
    aut.uri catalogs_all_path(:format => "atom", :auth_token => params[:auth_token], :author => @book.author, :user_id => @user.id)
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
  if @book.serie
   xml.link(:type => "application/atom+xml", :rel => "related", :href => catalogs_all_path(:format => "atom", :auth_token => params[:auth_token], :serie => @book.serie, :user_id => @user.id), :title => "From the same serie: " + @book.serie)
  end
  if @book.author
   xml.link(:type => "application/atom+xml", :rel => "related", :href => catalogs_all_path(:format => "atom", :auth_token => params[:auth_token], :author => @book.author, :user_id => @user.id), :title => "From the same author: " + @book.author)
  end
  if @book.category
   xml.link(:type => "application/atom+xml", :rel => "related", :href => catalogs_all_path(:format => "atom", :auth_token => params[:auth_token], :category => @book.category.id, :user_id => @user.id), :title => "From the same category: " + @book.category.name)
  end
end
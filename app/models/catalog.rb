
class Catalog < ActiveRecord::Base

  attr_accessor :added, :not_added

  has_many :catalog_books
  has_many :books, :through => :catalog_books
  belongs_to :user
  has_many :shared_catalogs
  has_many :shared_users, :through => :shared_catalogs, :source => :user

  validates_uniqueness_of :title, :scope => :user_id
  validates_presence_of :title

  before_save :generate_uuid

  def root_url
    "/catalogs/" + self.id.to_s + ".xml"
  end

  def opds_base
    feed = Atom::Feed.new do |f|
      f.title = self.title
      f.links << Atom::Link.new(:href => self.root_url, :rel => 'start', :type => "application/atom+xml;profile=opds-catalog;kind=navigation")
      f.updated = self.updated_at
      f.authors << Atom::Person.new(:name => self.user.name)
    end
    return feed
  end

  def opds
    feed = opds_base
    feed.links << Atom::Link.new(:href => self.root_url, :rel => 'self', :type => "application/atom+xml;profile=opds-catalog;kind=navigation")
    feed.entries << catalog_entry("Authors", self.root_url + "?authors=true", self.updated_at, "Sort by Authors")
    feed.id = self.id
    self.books.limit(5).order('created_at desc').each do |b|
      feed.entries << b.complete
    end
    return feed.to_xml
  end

  def all_books
    self.books
  end

  def new_books
    Book.where(Book[:catalog_id].eq(self.id)).where(Book[:update_at].lt(Date.now - 5))
  end

  def all_authors
    authors = self.books.collect{|b| b.author}.uniq
    feed = opds_base
    feed.title = self.title + " : " + "Authors"
    feed.links << Atom::Link.new(:href => self.root_url + "?authors=true", :rel => 'self', :type => "application/atom+xml;profile=opds-catalog")
    feed.links << Atom::Link.new(:href => self.root_url, :rel => 'up', :type => "application/atom+xml;profile=opds-catalog")
    authors.each do |a|
      if !a.blank?
        feed.entries << catalog_entry("Author : " + a, self.root_url + "?author=" + CGI::escape(a), self.updated_at, "Author : " + a)
      end
    end
    return feed.to_xml
  end

  def catalog_entry(title, link, updated_at, content, type = "subsection")
    entry = Atom::Entry.new do |e|
      e.title = title
      e.id = "urn:uuid:" + self.uuid
      e.updated = updated_at
      e.content = Atom::Content::Text.new(content)
      e.links << Atom::Link.new(:href => link,
        :rel => "http://opds-spec.org/" + type,
        :type => "application/atom+xml;profile=opds-catalog;kind=acquisition")
    end
    return entry
  end

  def author(author)
    books = Book.find(:all, :conditions => {:catalog_books => {:catalog_id => self.id}, :author => author}, :joins => :catalog_books)
    feed = opds_base
    feed.title = "Author : " + author
    feed.links << Atom::Link.new(:href => self.root_url + "?author=" + CGI::escape(author), :rel => 'self', :type => "application/atom+xml;profile=opds-catalog")
    feed.links << Atom::Link.new(:href => self.root_url + "?authors=true", :rel => 'up', :type => "application/atom+xml;profile=opds-catalog")
    books.each do |b|
      feed.entries << b.complete
    end
    return feed.to_xml
  end

  def not_added
    Book.find_by_sql ["SELECT * FROM books where user_id = ? AND id NOT IN (SELECT book_id FROM catalog_books WHERE catalog_id = ?)", self.user_id, self.id]
  end
  
  def self.all_public
    catalogs = Catalog.find(:all, :limit => 30)
  end

   def shared_with?(user_id)
    share = SharedCatalog.where(:catalog_id => self.id, :user_id => user_id)
    return !share.empty?
  end

private

  def generate_uuid
    if self.uuid.nil?
      self.uuid =  UUIDTools::UUID.timestamp_create().to_s
    end
  end
    
end

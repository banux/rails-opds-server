require 'digest/md5'

class Book < ActiveRecord::Base

include Tire::Model::Search
include Tire::Model::Callbacks

mount_uploader :epub, EpubUploader
mount_uploader :cover, CoverUploader

belongs_to :user
has_many :catalog_books
has_many :catalogs, :through => :catalog_books
validates_uniqueness_of :title, :scope => [:user_id, :author]
validates_presence_of :title

  #mapping do
  #      indexes :id,           :index    => :not_analyzed
  #      indexes :title, :boost => 2.0
  #      indexes :description
  #      indexes :author
  #      indexes :epub,         :index    => :not_analyzed
  #      indexes :cover,        :index    => :not_analyzed
  #      indexes :user_id,      :type     => 'string'
  #end

before_save :update_cover_attributes, :generate_uuid, :generate_md5

  def description()
    Sanitize.clean(read_attribute(:description), Sanitize::Config::RESTRICTED)
  end

  def import_metadata
    begin
    if self.epub
      epub_meta = Epub.new(Rails.public_path + self.epub.to_s)
      if epub_meta.respond_to?('creator') 
        self.author = epub_meta.creator
      end
      if epub_meta.respond_to?('title')
        self.title = epub_meta.title
      end
      if epub_meta.respond_to?('description')
        self.description = epub_meta.description
      end
      if(epub_meta.cover_image && epub_meta.cover_image.size)
        logger.debug "file path " + epub_meta.cover_image.path
        self.cover.store!(epub_meta.cover_image)
      end
    end
    rescue

    end
  end


   def partial

   end

   def complete
     entry = Atom::Entry.new do |e|
      e.title = self.title
      e.id = "urn:uuid:" + self.uuid
      e.updated = self.updated_at
      e.summary = self.description
      if self.author
       e.authors << Atom::Person.new(:name => self.author)
      end
      if self.epub
        e.links << Atom::Link.new(:href => self.epub.url,
          :rel => "http://opds-spec.org/acquisition", 
          :type => "application/epub+zip") 
      end
      if self.cover
       e.links << Atom::Link.new(:href => self.cover.medium.url, :rel => "http://opds-spec.org/image", :type => self.cover_type)
       e.links << Atom::Link.new(:href => self.cover.thumb.url, :rel => "http://opds-spec.org/image/thumbnail", :type => self.cover_type)
      end
#      xml.language = self.language
#      xml.issued = self.pub_date
#      xml.category = self.cat
     end
    return entry      
   end
#  <entry>
#    <title>Bob, Son of Bob</title>
#    <id>urn:uuid:6409a00b-7bf2-405e-826c-3fdff0fd0734</id>
#    <updated>2010-01-10T10:01:11Z</updated>
#    <author>
#      <name>Bob the Recursive</name>
#      <uri>http://opds-spec.org/authors/1285</uri>
#    </author>
#    <dc:language>en</dc:language>
#    <dc:issued>1917</dc:issued>
#    <category scheme="http://www.bisg.org/standards/bisac_subject/index.html"
#              term="FIC020000"
#              label="FICTION / Men's Adventure"/>
#    <summary>The story of the son of the Bob and the gallant part
#      he played in the lives of a man and a woman.</summary>
#    <link rel="http://opds-spec.org/image"
#          href="/covers/4561.lrg.png"
#          type="image/png"/>	
#    <link rel="http://opds-spec.org/image/thumbnail"
#          href="/covers/4561.thmb.gif"
#          type="image/gif"/>

#    <link rel="alternate"
#          href="/opds-catalogs/entries/4571.complete.xml"
#          type="application/atom+xml;type=entry;profile=opds-catalog"
#          title="Complete Catalog Entry for Bob, Son of Bob"/>
#
#    <link rel="http://opds-spec.org/acquisition"
#          href="/content/free/4561.epub"
#          type="application/epub+zip"/>
#    <link rel="http://opds-spec.org/acquisition"
#          href="/content/free/4561.mobi"
#          type="application/x-mobipocket-ebook"/>
# </entry>

def self.search_filter_user(params={})
  logger.debug "num page " + params[:page] if params[:page]
    Book.search :page => params[:page], :per_page => 20, :load => true do
       query do 
        boolean do
          must { string params[:name]}
          must { string 'user_id:' + params[:user_id].to_s }
        end
      end
      #end
      #sort { by :author, 'asc'}
      #facet "author" do
      #  terms 'author'
      #end
    end
  end

private

  def update_cover_attributes
    if cover.present? && cover_changed?
      self.cover_type = cover.file.content_type
    end
  end

  def generate_uuid
    if self.uuid.nil?
      self.uuid =  UUIDTools::UUID.timestamp_create().to_s
    end
  end

  def generate_md5
    if File.file?(Rails.public_path + self.epub.to_s)
      self.md5 = Digest::MD5.hexdigest(File.read(Rails.public_path + self.epub.to_s))
    end
  end

end

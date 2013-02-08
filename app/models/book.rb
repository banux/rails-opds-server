require 'digest/md5'

class Book < ActiveRecord::Base

include Tire::Model::Search
include Tire::Model::Callbacks
acts_as_taggable

mount_uploader :epub, EpubUploader
mount_uploader :cover, CoverUploader

belongs_to :user
belongs_to :category
has_many :read_lists
validates_uniqueness_of :title, :scope => [:user_id, :author]
validates_presence_of :title

  tire.mapping do
        indexes :id, :index => :not_analyzed
        indexes :author_keyword, :type => 'string', :analyzer => 'keyword'
        indexes :created_at, :type => 'date'
        indexes :tags, :type => "string", :analyzer => "keyword"
        indexes :serie_keyword, :type => "string", :analyzer => "keyword"
        indexes :serie, :type => "string"
        indexes :category, :index => :not_analyzed
        indexes :lang, :type => "string", :analyzer => "keyword"
  end

before_save :update_cover_attributes, :generate_uuid #, :generate_md5

  def to_indexed_json
    {
      :title => self.title,
      :description => self.description,
      :author => self.author,
      :author_keyword => self.author,
      :user_id => self.user_id,
      :created_at => self.created_at,
      :tags => tag_list,
      :serie_keyword => (serie.blank? ? nil : serie),
      :serie => (serie.blank? ? nil : serie),
      :serie_number => (serie_number.blank? ? nil : serie_number),
      :category => (category ? category.self_and_ancestors.collect {|c| c.id} : []),
      :lang => self.lang
    }.to_json
  end

  def description
    Sanitize.clean(read_attribute(:description), Sanitize::Config::RESTRICTED)
  end

  def import_metadata
    retry_num = 1
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
      if epub_meta.respond_to?('calibre_series_index')
        self.serie_number = epub_meta.calibre_series_index.to_i
      end
      if epub_meta.respond_to?('calibre_series')
        self.serie = epub_meta.calibre_series
      end
      if epub_meta.respond_to?('language')
        self.lang = epub_meta.language
      end
      if epub_meta.respond_to?('subject')
        cat = Category.find_by_name(epub_meta.subject)
        if cat
         self.category = cat
       end
      end
      if(epub_meta.cover_image && epub_meta.cover_image.size)
        logger.debug "file path " + epub_meta.cover_image.path
        self.cover.store!(epub_meta.cover_image)
      end
    end
    rescue => e
      Dir.mktmpdir {|dir|        
        system("cd #{dir}; unzip #{Rails.public_path + self.epub.to_s}; zip -r #{Rails.public_path + self.epub.to_s} *")
      }
      retry if (retry_num -= 1) > 0
      logger.debug(e)
      logger.info("can't parse epub " + self.epub.to_s)
    end
  end

  def read_book(user)
    read = ReadList.where(:user_id => user.id, :book_id => self.id).first
    if read.nil?
      read = ReadList.new
      read.user_id = user.id
      read.book_id = self.id
      read.save
    end
  end

  def unread_book(user)
    read = ReadList.where(:user_id => user.id, :book_id => self.id).first
    read.destroy unless read.nil?
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

  # def generate_md5
  #   if File.file?(Rails.public_path + self.epub.to_s)
  #     self.md5 = Digest::MD5.hexdigest(File.read(Rails.public_path + self.epub.to_s))
  #   end
  # end

end

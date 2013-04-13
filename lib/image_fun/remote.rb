require 'active_record'
module ImageFun
  module Remote
    def self.included(base)
      base.extend ClassMethods  
    end
    module ClassMethods
      def has_fun_with_remote_images(options={})
        attr_accessor :image_url, :file_upload, :refreshing_image
        before_validation :download_remote_image, :if => :image_url_provided?
        validates_presence_of :image_remote_url, :if => :image_url_provided?, :message => 'is invalid or inaccessible'
        validates_uniqueness_of :image_remote_url, :allow_nil => true
        class << self
          attr_accessor :column_name
        end
        @column_name = options[:column_name] || "pic"
        include ImageFun::Remote::InstanceMethods
      end
    end
    module InstanceMethods

      def remote_file_exists?(url)
        begin
          url = URI.parse(url)
          Net::HTTP.start(url.host, url.port) do |http|
            return http.head(url.request_uri).code == "200"
          end
        rescue
          return false
        end
      end

      def download_remote_image
        self.refreshing_image = true    
        self.send("#{self.class.column_name}=", do_download_remote_image)
        self.send("#{self.class.column_name}_file_name=", self.send(self.class.column_name).path.split("/").last)
        self.image_remote_url = image_url
        self.slugize_file_name    
      end

      def slugize_file_name
        extension = File.extname(self.send("#{self.class.column_name}_file_name")).downcase
        extension = ".jpg" if extension.blank?
        self.send("#{self.class.column_name}_file_name=", "#{self.slug}#{extension}")
      end
    
      private
      def image_url_provided?
        !self.image_url.blank?
      end

      def do_download_remote_image
        io = open(URI.parse(image_url.gsub(/\s+/, "%20")))
        def io.original_filename; base_uri.path.split('/').last; end
        io.original_filename.blank? ? nil : io
      rescue
        # catch url errors with validations instead of exceptions (Errno::ENOENT, OpenURI::HTTPError, etc...)        
      end      
    end
  end
end
ActiveRecord::Base.send(:include, ImageFun::Remote)
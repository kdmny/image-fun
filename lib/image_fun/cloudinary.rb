require 'active_record'
require 'action_view'
require 'cloudinary'
module ImageFun
  module Cloudinary
    def self.included(base)
      base.extend ClassMethods  
    end
    module ClassMethods
      def has_fun_with_cloudinary_images(options={})
        include ::CloudinaryHelper  
        after_save :upload_to_cloudinary, :if => :update_cloudinary?
        class << self
          attr_accessor :column_name, :cloudinary_options, :default_public_id
        end
        @column_name = options[:column_name] || "pic"        
        @default_public_id = options[:default_public_id] || "default"
        @cloudinary_options = options[:cloudinary_options] || [
          {:width => 640, :height => 500, :crop => :fill, :gravity => :faces, :format => :png},
          {:width => 310, :height => 310, :crop => :fill, :gravity => :faces, :format => :png},
          {:width => 100, :height => 100, :crop => :fill, :gravity => :faces, :format => :png}
        ]
        include ImageFun::Cloudinary::InstanceMethods
      end
    end
    module InstanceMethods
    
    
      def public_id
        return self.class.default_public_id if self.send("#{self.class.column_name}_file_name").blank?
        self.send("#{self.class.column_name}_file_name").split(".").reverse.drop(1).reverse.join(".")
      end
    
      def upload_to_cloudinary
        url = (self.send("#{self.class.column_name}_file_size").nil?) ? self.image_remote_url : self.send(self.class.column_name).url(:original)
        return if url.blank? || !remote_file_exists?(url)
        opts = {
          :public_id => self.public_id, 
          :version => self.send("#{self.class.column_name}_updated_at").to_i.to_s,
          :eager => self.class.cloudinary_options
        }
        opts.merge!({:tags => self.tags.collect(&:name)}) if self.respond_to?(:tags)
        ::Cloudinary::Uploader.upload(url, opts)
        self.refreshing_image = false
      end
    
      def config
        {}
      end

      def controller
        ActionController::Base.new
      end
    
      def cl_im_path(options = {})
        return "" if new_record?
        options[:format] ||= :png
        options[:height] ||= 300
        options[:crop] ||= :limit
        cl_image_path(self.public_id, options)
      end
      private
      def update_cloudinary?
        refreshing_image == true || !self.file_upload.blank?
      end
    end
  end
end
ActiveRecord::Base.send(:include, ImageFun::Cloudinary)
class Image < ActiveRecord::Base

  belongs_to :user

  has_attachment :content_type => :image,    
                   :processor => :MiniMagick,
                   :storage => :file_system, 
                   :max_size => 2000.kilobytes,
                   :resize_to => '480x360>',
                   :path_prefix => "/public/photo/",
                   :thumbnails => { :thumb => '100x100>' }

  validates_as_attachment

  before_thumbnail_saved do |record, thumbnail|
      thumbnail.user_id = record.user_id
      thumbnail.default = false
    end

end

#
# Texture files
#
class Texture < ApplicationRecord
  include WithFiles
  include Rails.application.routes.url_helpers
  
  self.inheritance_column = :inheritance_type
  
  before_destroy :remove_assets
  
  belongs_to :profile
  
  scope :active, -> {where(hidden: false)}
  scope :inactive, -> {where(hidden: true)}
  
  # accessor :hash
  # accessor :type
  # accessor :model
  
  #
  # Lock down
  #
  # We only support these three types of skins for now.
  #
  MODELS = %W[slim default].freeze
  TYPES = %W[skin elytra cape].freeze
  
  def self.models
    MODELS
  end
  
  def self.types
    TYPES
  end
  
  def self.check_model(model)
    MODELS.include?(model)
  end
  
  def self.check_type(model)
    TYPES.include?(model)
  end
  
  def json(host)
    {
      url:  URI::join(host, url),
      metadata: {
        type: type.upcase,
        model: model.downcase,
        active: !hidden
      }
    }
  end
  
  def url
    "/store/#{type.pluralize}/#{checksum}.png"
  end
  
  def asset_path
    return Rails.root.join('public', 'store', type.pluralize, "#{self.checksum}.png")
  end
  
  def update_assets(uploaded_io)
    if !validate_file(uploaded_io, 'image/png')
      return
    end
    
    remove_assets
    
    data = uploaded_io.read
    
    self.checksum = calculate_checksum(data)
    
    File.open(asset_path, 'wb') do |file|
      file.write(data)
      file.flush
    end
    
    self
  end
  
  protected
  def remove_assets
    if Texture.where("checksum = ? AND id != ?", checksum, id).count == 0
      del_file(asset_path)
    end
  end
end

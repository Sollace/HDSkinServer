#
# Texture files
#
class Texture < ApplicationRecord
  include WithFiles
  include Rails.application.routes.url_helpers
  
  before_destroy :remove_assets
  
  belongs_to :profile, dependent: :destroy
  
  # accessor :hash
  # accessor :type
  # accessor :model
  
  #
  # Lock down
  #
  # We only support these three types of skins for now.
  #
  MODELS = %W[skin elytra cape].freeze
  
  def self.check_model(model)
    MODELS.include?(model)
  end
  
  def json
    {
      model: model,
      url: url
    }
  end
  
  def url
    "#{root_path}/#{model}/#{hash}.png"
  end
  
  def asset_path
    Rails.root.join('public', model, "#{hash}.png")
  end
  
  def update_assets(uploaded_io)
    if !validate_file(uploaded_io, 'image/png')
      return
    end
    
    remove_assets
    
    hash = calculate_checksum(uploaded_io.read)
    
    save_file(asset_path, uploaded_io, 'image/png')
    
    self
  end
  
  protected
  def remove_assets
    del_file(asset_path)
  end
end

#
# Player Profiles
#
class Profile < ApplicationRecord
  has_many :textures
  
  # accessor :uuid
  # accessor :username
  
  def json
    response = {
      uuid: uuid,
      textures: {}
    }
    
    textures.each do |tex|
      response[:textures][tex.model.to_sym] = tex.json
    end
    
    response
  end
end

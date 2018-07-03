#
# Player Profiles
#
class Profile < ApplicationRecord
  has_many :textures, dependent: :destroy
  
  # accessor :uuid
  # accessor :username
  
  def self.lookup(params)
    return nil if !params[:uuid]
    
    if params[:uuid] == params[:user]
      return Profile.where(username: params[:user]).first
    end
    
    return Profile.where(uuid: params[:uuid]).first
  end
  
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

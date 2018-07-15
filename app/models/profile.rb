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
  
  def shallow_json
    {
      timestamp: Time.zone.now.to_i,
      profileId: uuid,
      profileName: username,
      isPublic: true
    }
  end
  
  def json(host)
    response = shallow_json
    response[:textures] = {}
    
    textures.active.each do |tex|
      response[:textures][tex.type.upcase] = tex.json(host)
    end
    
    response
  end
end

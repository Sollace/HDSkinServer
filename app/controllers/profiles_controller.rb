class ProfilesController < ApplicationController
  
  def show
    if params[:uuid] && (@profile = Profile.where(uuid: params[:uuid])).first
      return render json: {
        success: true,
        data: @profile.json
      }
    end
    
    render json: {
      success: false
    }
  end
  
  def gateway
    @type = params[:type].to_sym
    
    if params[:clear]
      destroy
    else
      upload
    end
  end
  
  def create
    if !params[:uuid]
      return head :access_denied
    end
    
    @model = params[:model]
    
    if !Texture.check_model(@model)
      return head :access_denied
    end
    
    @profile = Profile.where(uuid: params[:uuid]).first
    
    if !@profile
      @profile = Profile.create({
        uuid: params[:uuid],
        username: params[:user]
      })
    else
      @profile.username = params[:user]
      @profile.save
    end
    
    @texture = @profile.textures.where(type: @type)
    @skinFile = params[params[:type]]
    
    if @texture
      @texture.model = params[:model]
    else
      @texture = Texture.create({
        profile: @profile,
        type: @type,
        model: params[:model]
      })
    end
    
    @texture.update_assets(@skinFile)
    @texture.save
    
    head :ok
  end
  
  def destroy
    if !params[:uuid] && !(@profile = Profile.where(uuid: params[:uuid]).first)
      return head :not_found
    end
    
    @texture = @profile.textures.where(type: @type)
    
    if @profile.textures.count == 1
      @profile.destroy
    elsif @texture
      @texture.destroy
    end
    
    head :ok
  end
  
end

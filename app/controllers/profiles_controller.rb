class ProfilesController < ApplicationController
  skip_before_action :verify_authenticity_token, :only => [:gateway]
  
  def show
    if @profile = Profile.lookup(params)
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
    @type = params[:type]
    
    if params[:clear]
      destroy
    else
      create
    end
  end
  
  def create
    if !params[:uuid]
      return head :unauthorized
    end
    
    @model = params[:model]
    
    if !Texture.check_model(@model)
      return head :unauthorized
    end
    
    if !Texture.check_type(@type)
      return head :unauthorized
    end
    
    @file = params[@type]
    
    if !@file.content_type
      return render plain: "Unverifiable content type"
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
    
    @texture = @profile.textures.where(type: @type).first
    
    if @texture
      @texture.model = @model
    else
      @texture = @profile.textures.create({
        type: @type,
        model: params[:model]
      })
    end
    
    @texture.update_assets(@file)
    @texture.save
    
    render plain: "ok"
  end
  
  def destroy
    if !(@profile = Profile.lookup(params))
      return render plain: "ok"
    end
    
    @texture = @profile.textures.where(type: @type).first
    
    if @profile.textures.count == 1
      @profile.destroy
    elsif @texture
      @texture.destroy
    end
    
    render plain: "ok"
  end
  
end

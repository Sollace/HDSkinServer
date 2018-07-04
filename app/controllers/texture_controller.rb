class TextureController < ApplicationController
  skip_before_action :verify_authenticity_token, :only => [:gateway]
  
  def index
    if params[:username]
      @profile = Profile.where(username: params[:username]).first
    end
    
    
    
    if params[:format] == 'json'
      if @profile
        return render json: {
          success: true,
          data: @profile.textures.order(:updated_at).reverse_order.map(&:json)
        }
      end
      
      render json: {
        success: false
      }
    end
  end
  
  def update
    @hidden = params[:hidden] == 0;
    
    if (@texture = Texture.where(id: params[:id]).first)
      if @hidden != @texture.hidden
        Texture.where(type: @texture.type, model: @texture.model, profile_id: @texture.profile_id).update_all(hidden: true)
        
        if @hidden
          @newshown = Texture.where('type = ? AND profile_id = ? AND id != ?', @texture.type, @texture.profile_id, @texture.id).order(:updated_at, :created_at).first
          @newshown.hidden = false
          @newshown.save
        end
        
        @texture.hidden = @hidden
        @texture.save
      end
      
      
      return redirect_to action: :index, username: @texture.profile.username
      
    end
    
    redirect_to controller: :welcome, action: :index
  end
end

class TextureController < ApplicationController
  skip_before_action :verify_authenticity_token, :only => [:gateway]
  
  def index
    if params[:profile]
      @profile = Profile.where(username: params[:profile][:username]).first
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
end

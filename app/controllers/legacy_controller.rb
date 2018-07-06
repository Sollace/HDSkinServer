#
# Controller to handle legacy skin server requests.
# We can't trust the client to follow redirects so we look up and
# serve the correct files ourselves.
#
class LegacyController < ApplicationController
  
  def show
    
    params[:type] = params[:type].singularize
    
    if !(@profile = Profile.lookup(params))
      not_found
    end
    
    if !(@texture = @profile.textures.active.where(type: params[:type]).first)
      not_found
    end
      
    serve_direct(@texture.asset_path, 'image/png')
  end
  
  private
  def serve_direct(file, mime)
    if !File.exist?(file)
      not_found
    end
    
    response.headers['Content-Length'] = File.size(file).to_s
    send_file file.to_s, {
      disposition: 'inline',
      type: mime,
      filename: File.basename(file).to_s,
      x_sendfile: true
    }
  end
  
  def not_found
    raise ActionController::RoutingError.new('Not Found')
  end
end

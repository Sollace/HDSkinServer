class ApplicationController < ActionController::Base
  include Authenticated
  
  protect_from_forgery with: :exception
  
end

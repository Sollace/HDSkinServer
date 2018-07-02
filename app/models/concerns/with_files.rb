require 'digest/md5'

module WithFiles
  extend ActiveSupport::Concern
  
  def del_file(path)
    File.delete(path) if File.exist?(path)
  end
  
  def rename_file(from, to)
    if File.exist?(from)
      FileUtils.mv(from, to)
    end
  end
  
  def calculate_checksum(data)
    Digest::MD5.hexdigest(data)
  end
  
  def validate_file(uploaded_io, type)
    return uploaded_io && uploaded_io != true && uploaded_io.content_type.include?(type)
  end
  
  def save_file(path, uploaded_io, type)
    del_file(path)
    if !validate_file(uploaded_io, type)
      return false
    end
    
    File.open(path, 'wb') do |file|
      file.write(uploaded_io.read)
      file.flush
    end
    
    if block_given?
      yield
    end
    
    true
  end
  
end

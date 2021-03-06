require "sinatra/base"
require "mime/types"

class LogStash::Web::Server < Sinatra::Base
  get '/js/*' do static_file end
  get '/css/*' do static_file end
  get '/media/*' do static_file end
  get '/ws/*' do static_file end
  ## If here, we aren't running from a jar; safe to serve files
  ## through the normal public handler.
  #set :public, "#{File.dirname(__FILE__)}/public"

  def static_file
    # request.path_info is the full path of the request.
    path = File.join(File.dirname(__FILE__), "..", "public", *request.path_info.split("/"))
    #p :static => path
    if File.exists?(path)
      ext = path.split(".").last
      content_type MIME::Types.type_for(ext).first.to_s
      body File.new(path, "r").read
    else
      status 404
      content_type "text/plain"
      body "File not found: #{path}"
    end
  end # def static_file
end # class LogStash::Web::Server


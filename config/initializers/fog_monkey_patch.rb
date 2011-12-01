if defined?(Settings) && Settings[:s3]
  require 'fog'

  class Fog::Storage::AWS::Real
    def initialize_with_openteam(options={})
      initialize_without_openteam(options.merge(:scheme => :http, :port => 80, :host => 's3.openteam.ru'))
    end
    alias_method_chain :initialize, :openteam
  end

  class Fog::Connection
    def request_with_openteam(params, &block)
      request_without_openteam(params.merge(:path => "/#{Settings[:s3][:bucket_name]}/#{params[:path]}"), &block)
    end
    alias_method_chain :request, :openteam
  end
end

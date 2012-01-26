require 'dragonfly'

app = Dragonfly[:files]
app.configure_with(:rails)
app.define_macro(ActiveRecord::Base, :file_accessor)
app.configure_with(:imagemagick)
app.content_filename = ->(job, request) { request[:name] }
app.trust_file_extensions = false

if defined?(Settings) && Settings[:s3]
  app.datastore = Dragonfly::DataStorage::S3DataStore.new
  app.datastore.configure do |datastore|
    Settings[:s3].each do | key, value |
      datastore.send("#{key}=", value)
    end
  end
else
  app.datastore.configure do |datastore|
    datastore.root_path = "#{Rails.root}/files/#{Rails.env}"
    datastore.store_meta = false
  end
end

module Dragonfly
  module ImageMagick
    module Utils
      def raw_identify(temp_object, args='')
        throw :unable_to_handle if temp_object.original_filename =~ /.pdf/

        run(identify_command, "#{args} #{quote(temp_object.path)}")
      end
    end
  end
end


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
    datastore.root_path = "#{Rails.root}/.files/#{Rails.env}"
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

# Before usage set watermark.file in config/settings.yml
class Watermark
  include Dragonfly::Configurable
  include Dragonfly::ImageMagick::Utils

  def watermark(source_image)
    watermark_file = Rails.root.join(Settings['watermark.file'])
    watermark_resize = '30%'
    watermark_opacity = '90'

    convert(
      source_image,
      "-gravity SouthEast ( #{watermark_file} -resize #{watermark_resize} -geometry +0+0 ) -compose dissolve -define compose:args=#{watermark_opacity} -composite"
    )
  end
end

app.processor.register(Watermark)

# Uncomment for text watermark
# Before usage set watermark.text in config/settings.yml
#class TextWatermark
  #include Dragonfly::Configurable
  #include Dragonfly::ImageMagick::Utils

  #def text_watermark(source_image)
    #convert(
      #source_image,
      #"-fill white -undercolor '#00000080' -gravity SouthEast -annotate +1+1 '#{Settings['watermark.text']}'"
    #)
  #end
#end
# app.processor.register(TextWatermark)

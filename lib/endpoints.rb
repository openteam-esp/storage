class Endpoints
  def self.default(&block)
    Dragonfly[:files].endpoint do |params, app|
      if params[:width]
        image = FileEntry.where(:file_mime_directory => 'image').where(:name => params[:name]).find(params[:id])
        gravity = nil

        if params[:magnify]
          width = [params[:width].to_i, image.file_width*3, 2000].min
          height = [params[:height].to_i, image.file_height*3, 2000].min
        else
          width = [params[:width].to_i, image.file_width].min
          height = [params[:height].to_i, image.file_height].min
        end

        gravity = params[:gravity] if params[:cropify]
        modificator = '#' if params[:cropify]

        thumbnail = image.file.thumb("#{width}x#{height}#{modificator}#{gravity}").strip

        thumbnail = block.call(thumbnail) if block

        thumbnail
      else
        base_entry_name, *relative_path = params[:name].split('/')
        base_entry = FileEntry.where(:name => base_entry_name).find(params[:id])

        app.fetch base_entry.subfile(relative_path).file_uid
      end
    end
  end

  def self.region(&block)
    Dragonfly[:files].endpoint do |params, app|
      image = FileEntry.where(:file_mime_directory => 'image').where(:name => params[:name]).find(params[:id])

      width, height                 = params[:width], params[:height]
      x, y                          = params[:x], params[:y]
      resized_width, resized_height = params[:resized_width], params[:resized_height]

      gravity = params[:gravity] if params[:cropify]
      modificator = '#' if params[:cropify]

      thumbnail = image.file.thumb("#{width}x#{height}+#{x}+#{y}").strip

      thumbnail = thumbnail.thumb("#{resized_width}x#{resized_height}#{modificator}#{gravity}") if resized_width && resized_height

      thumbnail = block.call(thumbnail) if block

      thumbnail
    end
  end
end


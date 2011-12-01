class ElFinder::File < ElFinder::Entry
  def mime
    entry.file_mime_type
  end

  def size
    entry.file_size
  end

  def url(helper_name=:files, options={})
    Rails.application.routes.url_helpers.send("#{helper_name}_url", options.merge(id: entry.id, name: name, host: Settings['host']))
  end

  def tmb
    url(:resized_images, width: 48, height: 48)
  end

  def attributes
    attributes = super
    attributes << 'url'
    attributes << 'tmb' if entry.file_mime_directory == 'image' && entry.file_width && entry.file_height
    attributes
  end

end

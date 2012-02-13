class ElFinder::File < ElFinder::Entry
  def mime
    entry.file_mime_type
  end

  def size
    entry.file_size
  end

  def url
    if entry.image?
      url_for :resized_image, width: entry.file_width, height: entry.file_height
    else
      url_for :file
    end
  end

  def tmb
    url_for(:resized_image, width: 48, height: 48)
  end

  def attributes
    attributes = super
    attributes << 'url'
    attributes << 'tmb' if entry.image?
    attributes
  end

  protected
    def url_for(helper, options={})
      Rails.application.routes.url_helpers.send("#{helper}s_url", options.merge(id: entry.id, name: name, host: Settings['app.url']))
    end

end

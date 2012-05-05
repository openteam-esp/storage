class ElFinder::File < ElFinder::Entry
  def mime
    entry.file_mime_type
  end

  def size
    entry.file_size
  end

  def url
    entry.url
  end

  def tmb
    entry.resized_image_url width: 48, height: 48
  end

  def attributes
    attributes = super
    attributes << 'url'
    attributes << 'tmb' if entry.image?
    attributes
  end

end

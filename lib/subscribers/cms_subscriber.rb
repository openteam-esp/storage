class CmsSubscriber
  def lock_by_path(options)
    ExternalLock.create_by_path!(options)
  end

  def lock_by_url(options)
    ExternalLock.create_by_url!(options)
  end

  def unlock_by_path(options)
    ExternalLock.destroy_by_path(options)
  end

  def unlock_by_url(options)
    ExternalLock.destroy_by_url(options)
  end
end

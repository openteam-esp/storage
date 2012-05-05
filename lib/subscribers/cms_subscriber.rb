class CmsSubscriber
  def lock_by_url(params)
    ExternalLockByUrl.create!(params)
  end

  def lock_by_path(params)
    ExternalLockByPath.create!(params)
  end

  def unlock_by_path(params)
    ExternalLockByPath.where(params).destroy_all
  end

  def unlock_by_url(params)
    ExternalLockByUrl.where(params).destroy_all
  end
end

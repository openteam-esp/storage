class ElFinder::File < ElFinder::Entry
  delegate :size, :mime, :to => :entry

  def url
    Rails.application.routes.url_helpers.files_url(self.entry, :name => name, :host => Settings['system.host'])
  end

  def attributes
    super + ['url']
  end

end

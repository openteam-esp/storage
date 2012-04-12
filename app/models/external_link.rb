class ExternalLink < ActiveRecord::Base
  belongs_to :entry
  validates_presence_of :entry, :path, :url
  before_validation :find_entry, :if => :path?

  protected
    def find_entry
      self.entry = RootEntry.instance.find_by_path(path)
    end
end

class ExternalLockByUrl < Lock
  before_validation :find_entry, :if => :entry_url?

  validates_presence_of :entry_url, :external_url
  validates_uniqueness_of :external_url, :scope => :entry_id

  def to_s
    external_url
  end

  protected
    def find_entry
      entry_url.match(%r{#{Settings['app.url']}/files/(\d+)/}) do
        self.entry = FileEntry.find($1)
      end
    end
end
# == Schema Information
#
# Table name: locks
#
#  id            :integer         not null, primary key
#  type          :string(255)
#  entry_id      :integer
#  file_entry_id :integer
#  entry_path    :string(255)
#  entry_url     :string(255)
#  external_url  :string(255)
#  created_at    :datetime        not null
#  updated_at    :datetime        not null
#


class ExternalLockByPath < ExternalLock
  attr_accessible :entry_path, :external_url

  validates_presence_of :entry_path

  protected
    def find_entry
      self.entry = RootEntry.instance.find_by_path(entry_path)
    end
end

# == Schema Information
#
# Table name: locks
#
#  id            :integer          not null, primary key
#  type          :string(255)
#  entry_id      :integer
#  file_entry_id :integer
#  entry_path    :string(255)
#  entry_url     :string(255)
#  external_url  :string(255)
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#


class ExternalLock < Lock
  validates_presence_of :external_url
  validates_uniqueness_of :external_url, :scope => :entry_id

  before_validation :find_entry, :unless => :entry_id?

  def self.create_by_path!(options)
    ExternalLockByPath.create!(options) unless ExternalLockByPath.where(options).exists?
  end

  def self.create_by_url!(options)
    ExternalLockByUrl.create!(options) unless ExternalLockByUrl.where(options).exists?
  end

  def self.destroy_by_path(options)
    ExternalLockByPath.where(options).destroy_all
  end

  def self.destroy_by_url(options)
    ExternalLockByUrl.where(options).destroy_all
  end

  def to_s
    external_url
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


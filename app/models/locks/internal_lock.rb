class InternalLock < Lock
  attr_accessible :entry_id

  belongs_to :file_entry
  validates_presence_of :file_entry
  validates_uniqueness_of :file_entry_id, :scope => :entry_id
  validate :can_not_link_to_self

  def to_s
    file_entry.full_path
  end

  private
    def can_not_link_to_self
      errors.add(:file_entry, "Cann't create link to self") if entry == file_entry
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


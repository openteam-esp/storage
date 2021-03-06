class Entry < ActiveRecord::Base

  attr_accessible :name

  before_destroy :ensure_has_no_subtree_locks, :unless => :ancestry_callbacks_disabled?

  before_update :ensure_has_no_subtree_locks, :if => :name_changed?, :unless => :ancestry_callbacks_disabled?

  before_save :ensure_has_no_subtree_external_locks_by_path, :if => :ancestry_changed?, :unless => [:new_record?, :ancestry_callbacks_disabled?]

  validate :uniq_name_with_ancestry

  has_many :locks

  has_ancestry :cache_depth => true

  scope :directories, where(:type => ['DirectoryEntry', 'RootEntry'])

  validate :valdate_parent

  def duplicate
    Entry.transaction do
      dup.tap do | entry |
        entry.update_attributes!({ :name => entry.duplicate_name }, :without_protection => true)
        copy_descendants_to(entry)
      end
    end
  end

  def full_path
    "#{parent.full_path}/#{name}"
  end

  def file?
    false
  end

  protected

    def copy_descendants_to(entry)
    end

    def duplicate_name
      i = 0
      begin i += 1 end while parent.children.find_by_name(name_of_copy(i))
      name_of_copy(i)
    end

    def valdate_parent
      errors.add :parent, :must_be_a_directory if parent.is_a?(FileEntry)
    end

    def ensure_has_no_subtree_locks
      raise Exceptions::LockedEntry.new("#{full_path} locked by " + subtree_locks.join('<br/>')) if subtree_locks.any?
    end

    def ensure_has_no_subtree_external_locks_by_path
      raise Exceptions::LockedEntry.new("#{full_path} locked by " + subtree_external_locks_by_path.join('<br/>')) if subtree_external_locks_by_path.any?
    end

  private

    def uniq_name_with_ancestry
      return unless self.new_record?
      model = Entry.find(:first, :conditions => {:name => self.name, :ancestry => self.ancestry})
      unless model.blank?
        errors.add :name, "уже существует. url: #{model.url}"
      end
    end

    def subtree_locks
      @subtree_locks ||= Lock.where(:entry_id => subtree_ids).where(['(file_entry_id is null) or (file_entry_id not in (?))', subtree_ids])
    end

    def subtree_external_locks_by_path
      @subtree_external_locks_by_path = subtree_locks.where(:type => ExternalLockByPath)
    end

end

# == Schema Information
#
# Table name: entries
#
#  id                  :integer          not null, primary key
#  type                :string(255)
#  name                :text
#  ancestry            :string(255)
#  ancestry_depth      :integer
#  file_uid            :text
#  file_size           :integer
#  file_width          :integer
#  file_height         :integer
#  file_mime_type      :string(255)
#  file_mime_directory :string(255)
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#


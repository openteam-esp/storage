class Entry < ActiveRecord::Base
  has_ancestry :cache_depth => true

  scope :directories, where(:type => 'DirectoryEntry')


  validate :valdate_parent

  def directories
    DirectoryEntry.where :ancestry => child_ancestry
  end

  def files
    FileEntry.where :ancestry => child_ancestry
  end

  def duplicate
    Entry.transaction do
      dup.tap do | entry |
        entry.update_attributes! :name => entry.duplicate_name
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
      self.children.each do |child|
        child_copy = child.dup
        child_copy.update_attributes! :parent => entry
        child.copy_descendants_to(child_copy)
      end
    end

    def duplicate_name
      i = 0
      begin i += 1 end while parent.children.find_by_name(name_of_copy(i))
      name_of_copy(i)
    end

    def valdate_parent
      errors.add :parent, :must_be_a_directory if parent.is_a?(FileEntry)
    end

end

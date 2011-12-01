class DirectoryEntry < Entry
  validates_presence_of :name, :parent, :unless => :root?

  def directories
    DirectoryEntry.where :ancestry => child_ancestry
  end

  def files
    FileEntry.where :ancestry => child_ancestry
  end

  def find_or_create_by_path(path)
    path.to_s.split('/').inject(self) { | entry, name |
      entry.directories.find_by_name(name) || DirectoryEntry.create!(:parent => entry, :name => name)
    }
  end

  def find_by_path(path)
    path.to_s.split('/').inject(self) { | entry, name | entry.children.find_by_name!(name) }
  end

  protected
    def copy_descendants_to(entry)
      self.children.each do |child|
        child_copy = child.dup
        child_copy.update_attributes! :parent => entry
        child.copy_descendants_to(child_copy)
      end
    end

    def root?
      false
    end

    def name_of_copy(number)
      "#{name} copy#{number}"
    end
end

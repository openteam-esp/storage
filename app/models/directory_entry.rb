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
    path.to_s.split('/').reject(&:blank?).inject(self) { | entry, name | entry.children.find_by_name!(name) }
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
# == Schema Information
#
# Table name: entries
#
#  id                  :integer         not null, primary key
#  type                :string(255)
#  name                :string(255)
#  ancestry            :string(255)
#  ancestry_depth      :integer
#  file_uid            :string(255)
#  file_size           :integer
#  file_width          :integer
#  file_height         :integer
#  file_mime_type      :string(255)
#  file_mime_directory :string(255)
#  created_at          :datetime
#  updated_at          :datetime
#


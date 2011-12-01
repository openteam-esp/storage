class FileEntry < Entry
  validates_presence_of :name, :parent, :file

  alias_attribute :file_name, :name

  before_create :set_file_mime_directory

  file_accessor :file

  def file?
    true
  end

  def children
    DirectoryEntry.find(self)
  end

  protected

    def set_file_mime_directory
      self.file_mime_directory = file_mime_type.split('/')[0]
    end

    def name_of_copy(number)
      "#{file_basename} copy#{number}#{file_extname}"
    end

    def file_basename
      File.basename file.name, file_extname
    end

    def file_extname
      File.extname file.name
    end
end

class FileEntry < Entry
  validates_presence_of :name, :parent

  alias_attribute :file_size,       :size
  alias_attribute :file_name,       :name
  alias_attribute :file_mime_type,  :mime
  alias_attribute :file_uid,        :uid

  file_accessor :file

  def file?
    true
  end

  def children
    DirectoryEntry.find(self)
  end

  protected

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

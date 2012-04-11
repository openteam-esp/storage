class FileEntry < Entry
  validates_presence_of :name, :parent, :file

  alias_attribute :file_name, :name

  before_save :set_file_mime_directory
  before_save :find_links_to_another_files, :if => :text?

  before_update :ensure_has_no_links, :if => :name_changed?

  file_accessor :file

  has_many :links, :as => :linkable, :dependent => :destroy
  accepts_nested_attributes_for :links

  def file?
    true
  end

  def children
    DirectoryEntry.find(self)
  end

  %w[text audio video].each do | mime_directory |
    define_method "#{mime_directory}?" do
      mime_directory == file_mime_directory
    end
  end

  def image?
    file_mime_directory == 'image' && file_width? && file_height?
  end

  def file_path
    @file_path ||= path.map(&:name).join('/')
  end

  protected

    def set_file_mime_directory
      self.file_mime_directory = file_mime_type.split('/')[0]
    end

    def find_links_to_another_files
      self.links.delete_all
      self.links_attributes = self.file.data.scan(%r{#{Settings['app.url']}/files/(\d+)/}).flatten.map{|id| {:storage_file_id => id}}
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


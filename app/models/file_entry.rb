class FileEntry < Entry
  validates_presence_of :name, :parent, :file

  alias_attribute :file_name, :name

  before_save :set_file_mime_directory
  after_save :create_locks, :if => :text?

#  before_update :ensure_has_no_internal_links, :if => :name_changed?

  before_update :send_queue_message, :if => :file_uid_changed?

  has_many :internal_locks

  file_accessor :file

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

  def update_file_content(content)
    Dir.mktmpdir do |dir|
      File.open("#{dir}/#{name}", 'w') do |file|
        file.write(content)
        file.close
        self.file = file
        self.save!
      end
    end
  end

  protected
    def set_file_mime_directory
      self.file_mime_directory = file_mime_type.split('/')[0]
    end

    def create_locks
      internal_locks.destroy_all
      file.data.scan(%r{#{Settings['app.url']}/files/(\d+)/}).flatten.each do | id |
        internal_locks.create! :entry_id => id
      end
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

    def send_queue_message
      MessageMaker.make_message('esp.storage.cms', 'update_content', full_path)
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


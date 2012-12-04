class FileEntry < Entry
  validates_presence_of :name, :parent, :file

  alias_attribute :file_name, :name

  before_save :set_file_mime_directory
  after_save :create_locks, :if => :text?

  before_update :send_queue_message, :if => :file_uid_changed?

  has_many :internal_locks, :dependent => :destroy

  file_accessor :file

  def file?
    true
  end

  def children
    DirectoryEntry.find(self)
  end

  %w[text image].each do | mime_directory |
    define_method "#{mime_directory}?" do
      mime_directory == file_mime_directory
    end
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

  def resizable?
    image? && file_width? && file_height?
  end

  def url(options={})
    options.merge!(id: id, name: name)
    options.reverse_merge!(width: file_width, height: file_height) if resizable?
    Settings['app.url'] + Rails.application.routes.url_helpers.send("files_path", options)
  end

  protected
    def set_file_mime_directory
      self.file_mime_directory = file_mime_type.split('/')[0]
    end

    def create_locks
      old_entry_ids = internal_locks(true).pluck(:entry_id)
      new_entry_ids = file.data.scan(%r{#{Settings['app.url']}/files/(\d+)/}).flatten.uniq.map(&:to_i)

      entry_ids_to_add = new_entry_ids - old_entry_ids - [id]
      entry_ids_to_remove = old_entry_ids - new_entry_ids

      internal_locks.where(:entry_id => entry_ids_to_remove).destroy_all

      entry_ids_to_add.each do |id|
        internal_locks.create :entry_id => id
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
      MessageMaker.make_message('esp.storage.blue-pages', 'update_content', full_path)
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


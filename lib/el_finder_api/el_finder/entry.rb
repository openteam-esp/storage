class ElFinder::Entry < ElFinder::Model

  attr_accessor :entry

  delegate :entry, :to => :root, :prefix => true

  class << self
    def find_by_hash(hash)
      root_hash, entry_hash = hash.split('_')
      root_id = root_hash.scan(/^r(\d+)$/).first
      root = ::Entry.find_by_id(root_id)
      relative_entry_path = decode_path(entry_hash)
      el_root = ElFinder::Root.new :entry => root
      return el_root if relative_entry_path == '/'
      entry = relative_entry_path.split('/').inject(root) { | entry, name | entry.children.find_by_name(name) } if relative_entry_path.present?
      if entry.file?
        ElFinder::File.new :root => el_root, :entry => entry
      else
        ElFinder::Directory.new :root => el_root, :entry => entry
      end
    end

    def decode_path(hash)
      begin
        Base64.urlsafe_decode64 aligned(hash)
      rescue
        p aligned(hash)
      end
    end

    def aligned(hash)
      hash + ('=' * signs_count(hash))
    end

    def signs_count(hash)
      (hash.length % 4).zero? ? 0 : 4 - hash.length % 4
    end
  end

  def root
    ElFinder::Root.new :entry => RootEntry.instance
  end

  def name
    entry.name
  end

  def mime
    'directory'
  end

  def hash
    "#{root.volumeid}#{Base64.urlsafe_encode64(relative_path).strip.tr('=', '')}"
  end

  def date
    I18n.l(entry.updated_at)
  end

  def size
    0
  end

  def phash
    parent.hash
  end

  def read
    1
  end

  def write
    1
  end

  def locked
    0
  end

  def attributes
    %w[name mime hash date size phash read write locked]
  end

  def relative_path
    entry.path.from_depth(root_entry.depth + 1).map(&:name).join('/')
  end

  def full_path
    [root.full_path, relative_path].join('/')
  end

  protected

    def parent
      @parent ||= entry.parent == root.entry ? root : ElFinder::Directory.new(:entry => entry.parent)
    end

end

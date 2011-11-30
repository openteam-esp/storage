class ElFinder::Entry < ElFinder::Model

  attr_accessor :entry, :root

  delegate :entry, :to => :root, :prefix => true

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
      @parent ||= root.el_entry(entry.parent)
    end

end

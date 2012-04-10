class ElFinder::Root < ElFinder::Directory

  def self.for_path(path)
    ElFinder::Root.new :entry => RootEntry.instance.find_or_create_by_path(path)
  end

  def find_el_entry_by_hash(hash)
    root_hash, *entry_hash = hash.split('_')
    # root_id = root_hash.scan(/^r(\d+)$/).first
    # TODO: validate root_id == self.id
    el_entry_for_path(decode_path(entry_hash.join('_')))
  end

  def el_entry_for_path(path)
    el_entry(self.entry.find_by_path(path))
  end

  def el_entry(entry)
    if entry == self.entry || entry.nil?
      self
    elsif entry.file?
      ElFinder::File.new :root => self, :entry => entry
    else
      ElFinder::Directory.new :root => self, :entry => entry
    end
  end

  def hash
    "#{volumeid}Lw"
  end

  def phash
    ''
  end

  def name
    entry.parent ? entry.name : 'Root'
  end

  def volumeid
    "r#{entry.id}_"
  end

  def relative_path
    name
  end

  def full_path
    relative_path
  end

  protected

    def decode_path(hash)
      begin
        Base64.urlsafe_decode64 padded(hash)
      rescue
        p padded(hash)
      end
    end

    def padded(hash)
      hash + ('=' * signs_count(hash))
    end

    def signs_count(hash)
      (hash.length % 4).zero? ? 0 : 4 - hash.length % 4
    end
end

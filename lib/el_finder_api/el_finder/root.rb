class ElFinder::Root < ElFinder::Directory
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

  def attributes
    %w[name mime hash date size phash read write locked]
  end
end

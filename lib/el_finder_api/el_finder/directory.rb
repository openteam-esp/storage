class ElFinder::Directory < ElFinder::Entry
  def dirs
    entry.directories.any? ? 1 : 0
  end
end

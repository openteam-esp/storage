class ElFinder::File < ElFinder::Entry
  delegate :size, :mime, :to => :entry
end

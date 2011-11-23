class RootEntry < DirectoryEntry
  acts_as_singleton

  def full_path
    ""
  end

  protected
    def root?
      true
    end

    def valdate_parent
      errors.add(:parent, :must_be_nil) unless parent == nil
    end
end

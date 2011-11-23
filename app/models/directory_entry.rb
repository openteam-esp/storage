class DirectoryEntry < Entry
  validates_presence_of :name, :parent, :unless => :root?

  protected

    def root?
      false
    end

    def name_of_copy(number)
      "#{name} copy#{number}"
    end
end

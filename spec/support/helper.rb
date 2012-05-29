module Helper
  def directory(options={})
    @directory ||= Fabricate :directory_entry, options
  end
  alias :create_directory :directory

  def another_directory(options={})
    @another_directory ||= Fabricate :directory_entry, {:name => 'another_directory'}.merge(options)
  end
  alias :create_another_directory :another_directory

  def file(options={})
    @file ||= Fabricate :file_entry, options
  end
  alias :create_file :file

  def another_file(options={})
    @another_file ||= Fabricate :file_entry, {:name => 'anoter_file.txt'}.merge(options)
  end
  alias :create_another_file :another_file

  def root
    @root ||= RootEntry.instance
  end

  def command
    @command ||= described_class.new params
  end

  def result
    @result ||= command.result
  end

  def el_root(entry=root)
    @el_root ||= ElFinder::Root.new :entry => entry
  end

  def el_directory(options={})
    @el_directory ||= make_el_directory(options)
  end

  def make_el_directory(options={})
    ElFinder::Directory.new :root => el_root, :entry => (options.delete(:entry) || Fabricate(:directory_entry, options))
  end

  def el_file(options={})
    @el_file ||= ElFinder::File.new :root => el_root, :entry => file(options)
  end

end

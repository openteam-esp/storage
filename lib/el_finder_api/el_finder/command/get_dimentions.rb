module ElFinder
  class Command::GetDimentions < ElFinder::Command
    register_in_connector :dim

    class Arguments < Command::Arguments
      attr_accessor :target
      validates_presence_of :target
      validates :entry, :has => {:type => :file}
    end

    class Result < Command::Result
      def dim
        "#{arguments.entry.entry.file.width}x#{arguments.entry.entry.file.height}" if arguments.entry.entry.image?
      end
    end
  end
end

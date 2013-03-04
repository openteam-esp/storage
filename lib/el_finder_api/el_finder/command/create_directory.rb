module ElFinder
  class Command::CreateDirectory < ElFinder::Command
    register_in_connector :mkdir
    class Arguments < Command::Arguments
      attr_accessor :target, :name
      validates_presence_of :target, :name
      validates :entry, :has => {:type => :directory}
    end

    class Result < Command::Result
      def added
        [ execute_command ]
      end
    end

    protected
      def execute_command
        DirectoryEntry.create! do |dir|
          dir.parent = arguments.entry.entry
          dir.name = arguments.name
        end
      end
  end
end

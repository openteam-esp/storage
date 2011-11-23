module ElFinder
  class Command::CreateDirectory < ElFinder::Command
    register_in_connector :mkdir
    class Arguments < Command::Arguments
      attr_accessor :target, :name
      validates_presence_of :target, :name
      validates :entry, :is_a_directory => true
    end

    class Result < Command::Result
      def added
        [ execute_command ]
      end
    end

    protected
      def execute_command
        DirectoryEntry.create!(:parent => arguments.entry.entry, :name => arguments.name)
      end
  end
end

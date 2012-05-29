module ElFinder
  class Command::DuplicateEntries < ElFinder::Command
    register_in_connector :duplicate

    class Arguments < Command::Arguments
      attr_accessor :targets
      validates_presence_of :targets
      validates :entries, :has => {:type => :entry}
    end


    class Result < Command::Result
      def added
        execute_command
      end
    end

    protected

      def execute_command
        arguments.entries.map(&:entry).map(&:duplicate)
      end
  end
end

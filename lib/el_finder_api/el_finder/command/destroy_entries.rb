module ElFinder
  class Command::DestroyEntries < ElFinder::Command
    register_in_connector :rm

    class Arguments < Command::Arguments
      attr_accessor :targets
      validates_presence_of :targets
      validates :entries, :has => {:type => :entry}
    end

    class Result < Command::Result
      def removed
        arguments.targets
      end
    end

    protected

      def execute_command
        arguments.entries.map(&:entry).map(&:destroy)
      end

  end
end

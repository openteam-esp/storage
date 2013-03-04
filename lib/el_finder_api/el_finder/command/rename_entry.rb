module ElFinder
  class Command::RenameEntry < ElFinder::Command
    register_in_connector :rename

    class Arguments < Command::Arguments
      attr_accessor :target, :name
      validates_presence_of :target, :name
      validates :entry, :has => {:type => :entry}
    end

    class Result < Command::Result
      def added
        [execute_command]
      end
      def removed
        [arguments.target]
      end
    end

    protected
      def execute_command
        arguments.entry.entry.tap do | entry |
          entry.name = arguments.name
          entry.save!
        end
      end
  end
end

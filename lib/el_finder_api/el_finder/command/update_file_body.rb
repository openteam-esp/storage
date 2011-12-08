module ElFinder
  class Command::UpdateFileBody < Command
    register_in_connector :put

    class Arguments < Command::Arguments
      attr_accessor :target, :content
      validates_presence_of :target
      validates :entry, :is_a_file => true
    end

    class Result < Command::Result
      def added
        [arguments.entry]
      end
    end

    protected

      def execute_command
        arguments.entry.entry.tap do | entry |
          name = entry.name
          entry.file.assign arguments.content.to_s
          entry.file.save!
          entry.update_attributes! :name => name
        end
      end

  end
end

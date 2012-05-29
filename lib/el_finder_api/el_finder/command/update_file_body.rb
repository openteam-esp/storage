module ElFinder
  class Command::UpdateFileBody < Command
    register_in_connector :put

    class Arguments < Command::Arguments
      attr_accessor :target, :content
      validates_presence_of :target
      validates :entry, :has => {:type => :file}
    end

    class Result < Command::Result
      def added
        [arguments.entry]
      end
    end

    protected

      def execute_command
        arguments.entry.entry.update_file_content arguments.content.to_s
      end

  end
end

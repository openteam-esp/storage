module ElFinder
  class Command::ReadFileBody < ElFinder::Command
    register_in_connector :get

    class Arguments < Command::Arguments
      attr_accessor :target
      validates_presence_of :target
      validates :entry, :has => {:type => :file}
    end

    class Result < Command::Result
      def content
        arguments.entry.entry.file.data.force_encoding('utf-8')
      end
    end
  end
end

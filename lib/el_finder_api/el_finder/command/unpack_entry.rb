module ElFinder
  class Command::UnpackEntry < Command
    register_in_connector :extract

    class Arguments < Command::Arguments
      attr_accessor :target
      validates_presence_of :target
      validates :entry, :has => {:type => :file}
    end

    class Result < Command::Result
      def added
        [arguments.entry.entry.unpack]
      end
    end
  end
end

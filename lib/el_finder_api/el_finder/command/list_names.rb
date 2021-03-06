module ElFinder
  class Command::ListNames < ElFinder::Command
    register_in_connector :ls

    class Arguments < Command::Arguments
      attr_accessor :target

      validates_presence_of :target
      validates :entry, :has => {:type => :directory}
    end

    class Result < Command::Result
      def list
        arguments.entry.entry.children.map(&:name)
      end
    end
  end
end

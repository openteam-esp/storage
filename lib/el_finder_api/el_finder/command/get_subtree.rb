module ElFinder
  class Command::GetSubtree < ElFinder::Command
    register_in_connector :tree

    class Arguments < Command::Arguments
      attr_accessor :target

      validates_presence_of :target
      validates :entry, :has => {:type => :directory}
    end

    class Result < Command::Result
      def tree
        arguments.entry.entry.subtree(:to_depth => 1).directories
      end
    end

  end
end

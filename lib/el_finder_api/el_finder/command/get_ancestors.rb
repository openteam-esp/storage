module ElFinder
  class Command::GetAncestors < ElFinder::Command
    register_in_connector :parents

    class Arguments < Command::Arguments
      attr_accessor :target
      validates_presence_of :target
      validates :entry, :has => {:type => :directory}
    end

    class Result < Command::Result
      def tree
        [command.el_root.entry] + arguments.entry.entry.path(:to_depth => -1).from_depth(command.el_root.entry.depth).flat_map(&:directories)
      end
    end

  end
end

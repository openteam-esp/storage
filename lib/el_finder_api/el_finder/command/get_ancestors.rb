module ElFinder
  class Command::GetAncestors < ElFinder::Command
    register_in_connector :parents

    class Arguments < Command::Arguments
      attr_accessor :target
      validates_presence_of :target
      validates :entry, :is_a_directory => true
    end

    class Result < Command::Result
      def tree
        root = command.el_root.entry
        tree = arguments.entry.entry.ancestors.from_depth(root.depth)
        tree += arguments.entry.entry.ancestors.from_depth(root.depth).map(&:directories).flatten
        tree << arguments.entry.entry
        tree += ::Entry.where(['ancestry_depth <= ?', 2]).directories
        tree.uniq
      end
    end

  end
end

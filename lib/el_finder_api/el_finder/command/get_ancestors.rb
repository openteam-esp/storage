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
        tree = arguments.entry.entry.ancestors
        tree += arguments.entry.entry.ancestors.from_depth(1).map(&:directories).flatten
        tree << arguments.entry.entry
        tree += ::Entry.where(['ancestry_depth <= ?', 2]).directories
        tree.uniq
      end
    end

  end
end

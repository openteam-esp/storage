module ElFinder
  class Command::GetDescendants < ElFinder::Command
    register_in_connector :tree

    class Arguments < Command::Arguments
      attr_accessor :target

      validates_presence_of :target
      validates :entry, :is_a_directory => true
    end

    class Result < Command::Result
      def tree
        arguments.entry.entry.descendants(:to_depth => 2).directories
      end
    end

  end
end

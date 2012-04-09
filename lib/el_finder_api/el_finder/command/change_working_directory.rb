module ElFinder

  class Command::ChangeWorkingDirectory < Command
    register_in_connector :open

    class Arguments < Command::Arguments
      attr_accessor :init, :target, :tree

      validates_presence_of :init, :unless => :target
      validates :entry, :is_a_directory => true

      def initialize(params)
        super(params)
        self.target ||= command.el_root.hash if init
      end
    end

    class Result < Command::Result
      def cwd;        arguments.entry.entry end
      def api;        2                     end
      def uplMaxSize; '16m'                 end

      def files
        files = arguments.entry.entry.children.all
        if arguments.tree
          get_subtree = Command::GetSubtree.new(target: command.el_root.hash)
          get_subtree.run
          files = (files + get_subtree.result.tree).uniq
        end
        files
      end

      def options
        {disabled: [], separator: '/', copyOverwrite: 1, archivers: {create: [], extract: []}, path: arguments.entry.full_path}
      end
    end

  end

end

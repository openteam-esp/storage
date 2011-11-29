module ElFinder

  class Command::ChangeWorkingDirectory < Command
    register_in_connector :open

    class Arguments < Command::Arguments
      attr_accessor :init, :target, :tree

      validates_presence_of :init, :unless => :target
      validates :entry, :is_a_directory => true

      def initialize(params)
        super(params)
        self.target ||= ElFinder::Root.new(:entry => RootEntry.instance).hash if init
      end
    end

    class Result < Command::Result
      def cwd;        arguments.entry.entry end
      def api;        2                     end
      def uplMaxSize; '16m'                 end

      def files
        arguments.entry.entry.children.all
      end

      def options
        {path: arguments.entry.full_path, disabled: [], separator: '/', copyOverwrite: 1, archivers: {create: [], extract: []}}
      end
    end

  end

end

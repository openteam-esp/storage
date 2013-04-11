module ElFinder

  class Command::ChangeWorkingDirectory < Command
    register_in_connector :open

    class Arguments < Command::Arguments
      attr_accessor :init, :target, :tree

      validates_presence_of :init, :unless => :target
      validates :entry, :has => {:type => :directory}

      def initialize(params)
        super(params)
        self.target ||= command.el_root.hash if init
      end
    end

    class Result < Command::Result
      UNPACKABLE_MIME_TYPES = [
        'application/x-tar',
        'application/x-bzip2',
        'application/x-gzip',
        'application/x-xz',
        'application/x-compress',
        'application/zip',
      ]

      PACKABLE_MIME_TYPES = []

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
        {
          archivers: {
            create: PACKABLE_MIME_TYPES,
            extract: UNPACKABLE_MIME_TYPES,
          },
          copyOverwrite: 1,
          disabled: [],
          path: arguments.entry.full_path,
          separator: '/',
        }
      end

      def attributes
        arguments.init ? super : super - [:api, :uplMaxSize]
      end
    end

  end

end

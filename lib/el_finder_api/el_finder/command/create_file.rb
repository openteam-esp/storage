module ElFinder
  class Command::CreateFile < ElFinder::Command
    register_in_connector :mkfile

    class Arguments < Command::Arguments
      attr_accessor :target, :name
      validates_presence_of :target, :name
      validates :entry, :has => {:type => :directory}
    end

    class Result < Command::Result
      def added
        [ execute_command ]
      end
    end

    def execute_command
      FileEntry.new.tap do | file |
        Dir.mktmpdir do |dir|
          file.parent = arguments.entry.entry
          file.file = ::File.open("#{dir}/#{arguments.name}", "w")
          file.save!
        end
      end
    end
  end
end

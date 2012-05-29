module ElFinder
  class Command::UploadFiles < ElFinder::Command
    register_in_connector :upload

    class Arguments < Command::Arguments
      attr_accessor :target, :upload
      validates_presence_of :target
      validates :entry, :is_a_directory => true
    end

    class Result < Command::Result
       def added
         execute_command
       end
    end

    protected
      def execute_command
        arguments.upload.map do |file|
          filename = file.is_a?(::File) ? ::File.basename(file.path) : file.original_filename
          files = arguments.entry.entry.files
          if (file_entry = files.find_by_name(filename))
            file_entry.file = file
            file_entry.save!
          else
            file_entry = files.create! :file => file
          end
          el_root.el_entry(file_entry)
        end
      end
  end
end

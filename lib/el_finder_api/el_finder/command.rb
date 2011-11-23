module ElFinder

  class ::IsAFileValidator < ActiveModel::EachValidator
    def validate_each(record, attribute, value)
      record.errors[attribute] << "must be an instance of ElFinder::File (was #{value.class})" unless value.is_a?(ElFinder::File)
    end
  end

  class ::IsADirectoryValidator < ActiveModel::EachValidator
    def validate_each(record, attribute, value)
      record.errors[attribute] << "must be an instance of ElFinder::Directory (was #{value.class})" unless value.is_a?(ElFinder::Directory) || value.is_a?(ElFinder::Root)
    end
  end

  class ::IsAnEntryValidator < ActiveModel::EachValidator
    def validate_each(record, attribute, value)
      record.errors[attribute] << "must be an instance of ElFinder::Entry (was #{value.class})" unless value.is_a?(ElFinder::Entry)
    end
  end

  class Command < Model

    attr_accessor :arguments, :error, :result

    class Arguments < Model
      attr_accessor :command
      delegate :el_entry, :to => :command

      def entry
        el_entry(target)
      end
      def entries
        targets.map{|target| el_entry(target)}
      end
    end

    class Result < Model
      attr_accessor :arguments, :execute_command
    end

    class_attribute :command_name

    class Error < Model
      attr_accessor :error
    end

    def initialize(init_params)
      self.arguments = "#{self.class.name}::Arguments".constantize.new(init_params.merge(:command => self))
    end

    def run
      self.result = "#{self.class.name}::Result".constantize.new(:arguments => arguments, :execute_command => execute_command)
    end

    def headers
      @headers ||= {}
    end

    protected

      def el_entry(hash)
        ElFinder::Entry.find_by_hash hash
      end

      def execute_command
      end

      def self.register_in_connector(command_name=nil)
        self.command_name = command_name || name.demodulize.underscore
        Connector.commands[self.command_name] = self
      end
  end
end

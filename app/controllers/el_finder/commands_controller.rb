module ElFinder
  class CommandsController < ApplicationController
    #respond_to :json, :html

    def create
      command = ElFinder::Connector.new.command_for(params)
      command.run
      command.headers.each { |h,v| headers[h] = v }
      render :json => to_hash(command.result)
    end

    protected
      def to_hash(result)
        result.el_hash.inject({}) do | result, values |
          key, value = values
          result[key] = transform(value)
          result
        end
      end

      def transform(value)
        case value
        when RootEntry then ElFinder::Root.new(:entry => value).el_hash
        when DirectoryEntry then ElFinder::Directory.new(:entry => value, :root => ElFinder::Root.new(:entry => RootEntry.instance)).el_hash
        when FileEntry then ElFinder::File.new(:entry => value, :root => ElFinder::Root.new(:entry => RootEntry.instance)).el_hash
        when Array then value.map{|v| transform(v) }
        when Hash then value.inject({}) { |h, v| h[v[0]] = transform(v[1]); h }
        else value
        end
      end
  end
end


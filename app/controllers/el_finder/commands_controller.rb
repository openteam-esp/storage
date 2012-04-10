module ElFinder
  class CommandsController < ApplicationController
    #respond_to :json, :html

    def create
      begin
        command = ElFinder::Connector.new.command_for(params)
        command.run
        command.headers.each { |h,v| headers[h] = v }
        render :json => command.json
      rescue Exceptions::UndeletableEntry => e
        render :json => {error: e.message}
      end
    end

  end
end


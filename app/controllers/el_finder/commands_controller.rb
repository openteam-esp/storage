module ElFinder
  class CommandsController < ApplicationController
    #respond_to :json, :html

    def create
      command = ElFinder::Connector.new.command_for(params)
      command.run
      command.headers.each { |h,v| headers[h] = v }
      render :json => command.json
    end

    protected
  end
end


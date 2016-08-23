module Api
  class ApiController < ApplicationController
    def files_by_node
      @entry = DirectoryEntry.find_by_name(params[:node_name])

      render nothing: true, status: 404 and return if @entry.blank?

      respond_to do |format|
        format.html { render text: 'nothing here' }
        format.json do
          render 'files_by_node.jbuilder'
        end
      end
    end
  end
end

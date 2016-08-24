module Api
  class ApiController < ApplicationController
    before_filter :setup_headers

    def files_by_node
      @entry = DirectoryEntry.find(params[:directory_id])

      render nothing: true, status: 404 and return if @entry.blank?

      respond_to do |format|
        format.json do
          render 'files_by_node.jbuilder'
        end
      end
    end

    def find_entry_by_name
      @entries = DirectoryEntry.where('name ilike ?', %(%#{params[:term]}%))

      respond_to do |format|
        format.html { render text: 'nothing here' }
        format.json do
          render 'entries_for_autocomplete.jbuilder'
        end
      end
    end

    private

    def setup_headers
      headers['Access-Control-Allow-Origin'] = '*'
      headers['Access-Control-Request-Method'] = '*'
    end
  end
end

module Api
  class ApiController < ApplicationController
    def test
      @entry = DirectoryEntry.find_by_name(params[:node_name])
      @children = @entry.children

      respond_to do |format|
        format.html { render text: 'nothing here' }
        format.json do
          render 'test.jbuilder'
        end
      end
    end

    private

    def find_children_of_children(entry, children)
    end
  end
end

class ExternalLinksController < ApplicationController
  inherit_resources
  actions :create, :destroy
  respond_to :json

  protected
    def resource
      get_resource_ivar || set_resource_ivar(end_of_association_chain.find_by_path_and_url!(params[:path], params[:url]))
    end
end

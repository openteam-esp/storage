class ExternalLinksController < ApplicationController
  skip_before_filter :verify_authenticity_token
  respond_to :json

  inherit_resources
  actions :create, :destroy

  protected
    def resource
      get_resource_ivar ||
        set_resource_ivar(end_of_association_chain.find_by_path_and_url!(params[:external_link][:path], params[:external_link][:url]))
    end
end

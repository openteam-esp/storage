require 'spec_helper'

describe ExternalLinksController do
  describe '#destroy' do
    let(:external_link) { Fabricate :external_link, :path => file.full_path }
    alias_method :create_external_link, :external_link
    def do_destroy
      delete :destroy, :external_link => {:path => external_link.path, :url => external_link.url}
    end

    before { create_external_link }

    specify { expect{do_destroy}.to change{ExternalLink.count}.by(-1)}

    context 'wrong path' do
      specify { expect{delete :destroy, :external_link => {:path => '/ololo', :url => external_link.url}}.to raise_exception ActiveRecord::RecordNotFound }
    end
  end
end

# encoding: utf-8

require 'spec_helper'

module ElFinder
  describe Command::SendFile do
    context '(target: file)' do
      let(:params) { {target: el_file.hash} }

      subject { command }
      before { command.run }

      its(:headers) { should include_hash('Location' => el_file.url) }
    end
  end
end

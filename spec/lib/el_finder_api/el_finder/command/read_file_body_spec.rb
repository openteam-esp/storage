# encoding: utf-8

require 'spec_helper'

module ElFinder

  describe Command::ReadFileBody do
    let(:params)        { {target: el_file.hash} }

    describe '#result' do
      subject { command.result }
      before  { command.run }

      its(:content)     { should == file.file.data }
    end
  end

end

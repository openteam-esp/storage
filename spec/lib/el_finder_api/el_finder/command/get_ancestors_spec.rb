require 'spec_helper'

module ElFinder

  describe Command::GetAncestors do
    describe '#result #tree' do

      before { command.run }
      subject { command.result.tree }

      context 'target: root' do
        let(:params) { {target: el_root.hash} }
        it { should == [root] }
      end

      context 'target: directory' do
        let(:params) { {target: el_directory.hash} }
        it { should == [root, directory] }
      end

      context 'target: subdirectory' do
        let(:params) { {target: el_directory(:entry => another_directory(:parent => directory)).hash} }
        it { should == [root, directory, another_directory] }
      end

    end
  end
end

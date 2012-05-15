require 'spec_helper'

module ElFinder

  describe Command::ListNames do
    describe '#result #tree' do

      before { command.run }
      subject { command.result.list }

      context 'target: root' do
        let(:params) { {target: el_root.hash} }
        it { should == [] }
      end

      context 'with child directory' do
        before { directory }
        before { another_directory parent: directory, :name => 'ololo' } # make subdirectory
        before { el_file }
        let(:params) { {target: el_root.hash } }
        it { should == [directory.name, el_file.name] }
      end

    end
  end
end

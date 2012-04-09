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
        it { should == [root, el_directory.entry] }
      end

      context 'target: subdirectory' do
        let(:el_subdirectory) { el_directory(:entry => another_directory(:parent => directory)) }
        let(:params) { {target: el_subdirectory.hash} }
        it { should == [root, directory, another_directory] }

        context 'with child' do
          before { Fabricate :directory_entry, :parent => el_subdirectory.entry }
          it { should == [root, directory, another_directory] }
        end

        context 'with siblings' do
          before { @subdirectory_sibling = Fabricate :directory_entry, :parent => directory }
          it { should == [root, directory, another_directory, @subdirectory_sibling ] }
        end

        context 'directory has sibling' do
          before { @directory_sibling = Fabricate :directory_entry, :parent => root }
          it { should == [root, directory, @directory_sibling, another_directory] }

          context 'sibling has child' do
            before { Fabricate :directory_entry, :parent => @directory_sibling }
            it { should == [root, directory, @directory_sibling, another_directory] }
          end
        end
      end

    end
  end
end

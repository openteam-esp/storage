require 'spec_helper'

module ElFinder

  describe Command::GetSubtree do
    before { command.run }

    describe '#result'  do
      describe '#tree' do
        subject { result.tree }

        context 'target: root' do
          let(:params) { {target: el_root.hash} }

          context 'without subdirectories' do
            before { create_file }
            it { should == [root]}
          end

          context 'with subdirectory' do
            before { create_directory }
            it { should == [root, directory] }
          end

          context 'with directories at 2 level' do
            before { create_another_directory(:parent => directory) }
            it { should == [root, directory] }

            context 'with directories at 3 level' do
              before { Fabricate :directory_entry, :parent => another_directory }
              it { should == [root, directory] }
            end
          end
        end

        context 'target: directory' do
          let(:params)          { {target: el_directory(:entry => directory).hash } }

          context 'without subdirectories' do
            before { create_file(:parent => directory) }
            it { should == [directory]}
          end

          context 'with subdirectories at 2 level' do
            before { create_another_directory(:parent => directory) }
            it { should == [directory, another_directory] }

            context 'with directories at 3 level' do
              before { Fabricate :directory_entry, :parent => another_directory }
              it { should == [directory, another_directory] }
            end
          end
        end

      end

    end

  end
end

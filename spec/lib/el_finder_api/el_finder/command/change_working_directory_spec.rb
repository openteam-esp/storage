require 'spec_helper'
require 'ostruct'

module ElFinder

  describe Command::ChangeWorkingDirectory do

      describe '#result' do
        subject { result }

        before { command.run }

        let(:options)       { OpenStruct.new result.options }

        context '(init: true)' do
          let(:params)            { {init: true} }

          its(:api)             { should == 2 }
          its(:cwd)             { should == root }
          its(:uplMaxSize)      { should == '16m' }
          its(:attributes)      { should include(:api) }
          its(:attributes)      { should include(:uplMaxSize) }

          describe '#files' do
            context 'files not exists' do
              its(:files)           { should == [] }
            end
            context 'files exists'  do
              before              { create_file }

              its(:files)         {  should == [file] }
            end
          end
          describe '#options'  do
            subject             { options }

            its(:path)          { should == el_root.name }
            its(:disabled)      { should == [] }
            its(:separator)     { should == '/' }
            its(:copyOverwrite) { should == 1 }
            its(:archivers)     { should == {create: [], extract: []} }
          end
        end

        context '(target: directory)' do
          let(:params)          { {target: el_directory(:entry => directory).hash} }
          its(:attributes)      { should_not include(:api) }
          its(:attributes)      { should_not include(:uplMaxSize) }
        end

        context '(init: true, target: directory)' do
          let(:params)          { {init: true, target: el_directory(:entry => directory).hash} }

          its(:api)             { should == 2}
          its(:cwd)             { should == directory }
          its(:uplMaxSize)      { should == '16m' }

          describe '#files' do
            context 'when files in root dir'  do
              before            { create_file }
              its(:files)       { should == [] }
            end
            context 'when files and dirs in current dir'  do
              before            { create_file(:parent => directory) }
              before            { create_another_directory(:parent => directory) }

              its(:files)       { should == [file, another_directory] }
            end
          end

          describe '#options' do
            subject { options }

            its(:path)          { should == 'Root/directory' }
            its(:disabled)      { should == [] }
            its(:separator)     { should == '/' }
            its(:copyOverwrite) { should == 1 }
            its(:archivers)     { should == {create: [], extract: []} }
          end
        end


        context '(init: true, target: subdirectory, tree: true)' do

          let(:subdirectory)  { make_el_directory(:entry => Fabricate(:directory_entry, :parent => directory)) }
          let(:params)        { {init: true, target: subdirectory.hash, tree: true} }

          before              { create_file(:parent => root) }
          before              { @file_in_dir = Fabricate :file_entry, :parent => subdirectory.entry }

          its(:api)           { should == 2 }
          its(:cwd)           { should == subdirectory.entry }
          its(:files)         { should == [@file_in_dir, root, directory] }
        end

    end
  end

end

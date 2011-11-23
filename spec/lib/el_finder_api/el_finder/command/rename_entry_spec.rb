require 'spec_helper'

module ElFinder

  describe Command::RenameEntry do

    before            { command.run }

    context '(target: directory)' do
      let(:params)      { {target: el_directory.hash, :name => 'new_name'} }

      describe '#run' do
        it            { el_directory.entry.reload.name.should == 'new_name' }
      end

      describe '#result' do
        let(:subject) { command.result }

        its(:added)   { should == [el_directory.entry.reload] }
        its(:removed) { should == [params[:target]] }
      end
    end

    context '(target: file)' do
      let(:params)      { {target: el_file.hash, :name => 'new_name'} }

      describe '#run' do
        it            { el_file.entry.reload.name.should == 'new_name' }
      end

      describe '#result' do
        let(:subject) { command.result }

        its(:added)   { should == [file] }
        its(:removed) { should == [params[:target]] }
      end
    end

  end

end

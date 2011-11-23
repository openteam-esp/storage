# encoding: utf-8

require 'spec_helper'

module ElFinder

  describe Command::UpdateFileBody do
    let(:params)        { {target: el_file.hash, :content => '123'} }

    describe 'target: file' do
      before { command.run }
      subject { result }

      its(:added)        { should have(1).items }

      describe '#result #added [0]' do
        subject { result.added.first }

        its(:name) { should == 'file.txt' }
        its(:size) { should == 3 }

        describe '#entry' do
          subject { result.added.first.entry }

          its(:name) { should == 'file.txt' }

          describe '#file' do
            subject { result.added.first.entry.file }

            its (:data) { should == '123' }
          end
        end
      end
    end
  end

end

# encoding: utf-8

require 'spec_helper'

module ElFinder

  describe Command::UploadFiles do
    let(:files)     { [::File.open("#{Rails.root}/spec/fixtures/file.txt")] }
    let(:params)    { {target: el_root.hash, upload: files} }

    describe '#run' do
      it            { expect{command.run}.to change{root.files.count}.by(1) }
      context 'file already exists' do
        before      { root.files.create! :file => ::File.open("#{Rails.root}/spec/fixtures/another/file.txt") }
        it          { expect{command.run}.to_not change{root.files.count} }
        it          { expect{command.run}.to     change{root.files.first.file.data} }
      end
    end
    describe 'result' do
      let(:subject) { command.result }
      before        { command.run }
      its(:added)   { subject.map(&:name).should == ['file.txt'] }
    end
  end

end

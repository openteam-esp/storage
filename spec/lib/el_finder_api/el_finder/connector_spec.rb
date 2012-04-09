# encoding: utf-8

require 'spec_helper'

module ElFinder

  describe Connector do

    let(:connector) { Connector.new }
    let(:directory)  { Fabricate :directory }
    def command_for(name)
      connector.command_for(:cmd => name)
    end
    describe 'поиск команд' do
      it { command_for(:not_supported).should be_a(ElFinder::Command::Unknown) }
      it { command_for(:duplicate).should be_a(ElFinder::Command::DuplicateEntries) }
      it { command_for(:put).should be_a(ElFinder::Command::UpdateFileBody) }
      it { command_for(:file).should be_a(ElFinder::Command::SendFile) }
      it { command_for(:mkdir).should be_a(ElFinder::Command::CreateDirectory) }
      it { command_for(:mkfile).should be_a(ElFinder::Command::CreateFile) }
      it { command_for(:open).should be_a(ElFinder::Command::ChangeWorkingDirectory) }
      it { command_for(:parents).should be_a(ElFinder::Command::GetAncestors) }
      it { command_for(:paste).should be_a(ElFinder::Command::CopyEntries) }
      it { command_for(:ping).should be_a(ElFinder::Command::Ping) }
      it { command_for(:get).should be_a(ElFinder::Command::ReadFileBody) }
      it { command_for(:rename).should be_a(ElFinder::Command::RenameEntry) }
      it { command_for(:rm).should be_a(ElFinder::Command::DestroyEntries) }
      it { command_for(:tree).should be_a(ElFinder::Command::GetSubtree) }
      it { command_for(:upload).should be_a(ElFinder::Command::UploadFiles) }
      xit { command_for(:archive).should be_a(ElFinder::Command::PackEntries) }
      xit { command_for(:extract).should be_a(ElFinder::Command::UnpackEntry) }
      xit { command_for(:resize).should be_a(ElFinder::Command::ResizeImage) }
      xit { command_for(:tmb).should be_a(ElFinder::Command::CreateThumbnail) }
    end
  end
end

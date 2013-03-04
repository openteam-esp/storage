require 'spec_helper'

describe FileEntry do
  it { should have_many(:internal_locks).dependent(:destroy) }
  it { should validate_presence_of :name }
  it { should validate_presence_of :parent }
  it { should_not allow_value(file).for(:parent) }
  it { should allow_value(root).for(:parent) }
  it { should allow_value(directory).for(:parent) }

  context 'created' do
    subject { file }

    its(:name) { should == 'file.txt' }
    its(:file_size) { should > 0 }
    its(:file_mime_type) { should == 'text/plain' }
    its(:file_mime_directory) { should == 'text' }
    its('file.data') { should == "some text\n" }
    its(:full_path) { should == "/file.txt" }

    context 'in directory' do
      subject { file(:parent => directory) }

      its(:full_path) { should == '/directory/file.txt' }
    end

    describe '#duplicate' do
      before { create_file }
      it { expect{file.duplicate}.to change{root.files.count}.by(1) }
    end

    describe 'duplicated' do
      subject { file.duplicate }

      its(:name) { should == 'file copy1.txt'}

      context 'when file name have no extention' do
        before { file.update_attributes!({ :name => 'file' }, :without_protection => true)}

        its(:name) { should == 'file copy1'}
      end
    end
  end

  context 'created with image file' do
    subject { file(:file => File.new("#{Rails.root}/spec/fixtures/picture.txt")) }

    its(:file_mime_type) { should == 'image/png' }
    its(:file_mime_directory) {  should == 'image' }
  end

  context 'with internal locks' do
    before { Settings['app.url'] = 'http://localhost:3001'}
    before { file(:parent => directory) }
    let(:subdirectory) { Fabricate :directory_entry, :parent => another_directory}
    let(:create_another_file)  { another_file(:file => File.new("#{Rails.root}/spec/fixtures/content_with_link_to_file.xhtml"), :parent => subdirectory) }
    before { create_another_file }

    subject { file }

    its('locks.count') { should == 1 }

    specify { expect{file.destroy}.should raise_error }
    specify { expect{file.update_attributes!({ :name => 'new.txt' }, :without_protection => true)}.should raise_error }
    specify { expect{directory.destroy}.should raise_error }

    specify { expect{another_file.destroy}.should_not raise_error }
    specify { expect{another_file.update_attributes!({ :name => 'new.txt'}, :without_protection => true)}.should_not raise_error }
    specify { expect{another_directory.destroy}.should_not raise_error }

    specify { expect{file.update_file_content('absolutely new content')}.should_not raise_error }

    describe 'physical file should exists if was attempt of removing locked directory' do
      before { @yet_another_file = Fabricate :file_entry, :file => File.new("#{Rails.root}/spec/fixtures/another_file.txt"), :parent => directory }
      before { Entry.with_scope(Entry.order('id desc')) { directory.destroy rescue nil } }
      specify { FileEntry.find(file.id).file.data.should_not be_nil }
      specify { FileEntry.find(@yet_another_file.id).file.data.should_not raise_exception Dragonfly::DataStorage::DataNotFound }
    end

    describe 'we can delete whole dir if files cross-linked inside this dir' do
      let(:create_another_file)  { another_file(:file => File.new("#{Rails.root}/spec/fixtures/content_with_link_to_file.xhtml"), :parent => directory) }
      specify { expect{ directory.destroy }.should_not raise_exception }
    end

    describe 'should have only one link even after double save' do
      subject { file }
      before { another_file.save! }
      its('locks.count') { should == 1 }
    end
  end

  context 'whith external locks' do
    context 'by path' do
      before { Fabricate :external_lock_by_path, :entry_path => entry.full_path }
      context 'on directory' do
        let(:entry) {directory}
        describe '#update' do
          context 'parent' do
            specify { expect{directory.update_attribute(:parent, another_directory)}.should raise_exception Exceptions::LockedEntry }
            specify { expect{file(:parent => directory).update_attribute(:parent, another_directory)}.should_not raise_exception Exceptions::LockedEntry }
          end
          context 'name' do
            specify { expect{directory.update_attribute(:name, 'new_name')}.should raise_exception Exceptions::LockedEntry }
            specify { expect{file(:parent => directory).update_attribute(:name, 'new_name')}.should_not raise_exception Exceptions::LockedEntry }
          end
        end
        describe '#destroy' do
          specify { expect{file(:parent => directory).destroy}.should_not raise_exception Exceptions::LockedEntry }
          specify { expect{directory.destroy}.should raise_exception Exceptions::LockedEntry }
        end
      end
      context 'on file' do
        let(:entry) { file(:parent => directory) }
        describe '#update' do
          context 'parent' do
            specify { expect{file.update_attribute(:parent, another_directory) }.should raise_exception Exceptions::LockedEntry }
            specify { expect{directory.update_attribute(:parent, another_directory) }.should raise_exception Exceptions::LockedEntry }
          end
          context 'content' do
            specify { expect{file.update_file_content('123123')}.should_not raise_exception Exceptions::LockedEntry }
          end
        end
        describe '#destroy' do
          specify { expect{file.destroy}.should raise_exception Exceptions::LockedEntry }
          specify { expect{directory.destroy}.should raise_exception Exceptions::LockedEntry }
        end
      end
    end
  end

  context 'sending messages' do
    describe '#update' do
      context 'when file content changed' do
        before { MessageMaker.should_receive(:make_message).with('esp.storage.cms', 'update_content', file.full_path) }
        before { MessageMaker.should_receive(:make_message).with('esp.storage.blue-pages', 'update_content', file.full_path) }

        specify { file.update_file_content '0123456789' }
      end

      context 'when file content not changed' do
        before { MessageMaker.should_not_receive(:make_message) }

        specify { file.update_attribute :name, 'ololo.txt' }
      end
    end
  end
end

# == Schema Information
#
# Table name: entries
#
#  id                  :integer         not null, primary key
#  type                :string(255)
#  name                :string(255)
#  ancestry            :string(255)
#  ancestry_depth      :integer
#  file_uid            :string(255)
#  file_size           :integer
#  file_width          :integer
#  file_height         :integer
#  file_mime_type      :string(255)
#  file_mime_directory :string(255)
#  created_at          :datetime
#  updated_at          :datetime
#


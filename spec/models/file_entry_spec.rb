require 'spec_helper'

describe FileEntry do
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
    specify { expect{file.destroy}.should_not raise_error }

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
        before { file.update_attributes!(:name => 'file')}

        its(:name) { should == 'file copy1'}
      end
    end
  end

  context 'created with image file' do
    subject { file(:file => File.new("#{Rails.root}/spec/fixtures/picture.txt")) }

    its(:file_mime_type) { should == 'image/png' }
    its(:file_mime_directory) {  should == 'image' }
  end

  context 'with links to another file in content' do
    before { file }
    before { another_file(:file => File.new("#{Rails.root}/spec/fixtures/content_with_link_to_file.xhtml")) }
    specify { expect{file.destroy}.should raise_error }
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


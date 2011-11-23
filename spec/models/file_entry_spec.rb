require 'spec_helper'

describe FileEntry do
  it                  { should validate_presence_of :name }
  it                  { should validate_presence_of :parent }
  it                  { should_not allow_value(file).for(:parent) }
  it                  { should allow_value(root).for(:parent) }
  it                  { should allow_value(directory).for(:parent) }

  context 'created' do
    subject { file }

    its(:name)        { should == 'file.txt' }
    its(:size)        { should > 0 }
    its(:mime)        { should == 'text/plain' }
    its('file.data')  { should == "some text\n" }
    its(:full_path)   { should == "/file.txt" }

    context 'in directory' do
      subject { file(:parent => directory) }

      its(:full_path) { should == '/directory/file.txt' }
    end

    describe '#duplicate' do
      before          { create_file }
      it              { expect{file.duplicate}.to change{root.files.count}.by(1) }
    end

    describe 'duplicated' do
      subject         { file.duplicate }

      its(:name)      { should == 'file copy1.txt'}

      context 'when file name have no extention' do
        before        { file.update_attributes!(:name => 'file')}

        its(:name)    { should == 'file copy1'}
      end
    end
  end
end

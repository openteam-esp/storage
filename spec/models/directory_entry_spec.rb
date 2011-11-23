# encoding: utf-8

require 'spec_helper'

describe DirectoryEntry do
  it                    { should validate_presence_of :name }
  it                    { should validate_presence_of :parent }
  it                    { should_not allow_value(file).for(:parent) }
  it                    { should allow_value(root).for(:parent) }
  it                    { should allow_value(directory).for(:parent) }

  context 'created' do
    subject             { directory }

    its(:name)          { should == 'directory' }
    its(:full_path)     { should == '/directory' }

    context 'in directory' do
      subject           { another_directory(:parent => directory) }

      its(:name)        { should == 'directory' }
      its(:full_path)   { should == '/directory/directory' }
    end
  end

  describe '#duplicate' do
    before              { create_directory }

    it                  { expect{directory.duplicate}.to change{root.directories.count}.by(1) }
  end

  context 'dublicated' do
    let(:duplicated)    { directory.duplicate }
    subject             { duplicated }

    its(:name)          { should == 'directory copy1' }

    context 'must copy subentries' do
      before            { create_another_directory(:parent => directory) }
      before            { create_file(:parent => another_directory) }

      its(:children)    { should have(1).items }

      describe '#descendants' do
        subject         { duplicated.descendants }

        it              { should have(2).items }

        describe '#first' do
          subject       { duplicated.descendants.first }

          its(:name)    { should == 'directory' }
          its(:depth)   { should == 2 }
        end

        describe '#last' do
          subject       { duplicated.descendants.last }

          its(:name)    { should == 'file.txt' }
          its(:depth)   { should == 3 }
        end
      end
    end

    context 'if copies already exists' do
      before            { create_another_directory(:name => 'directory copy1') }

      its(:name)        { should == 'directory copy2' }
    end
  end

end

# encoding: utf-8

require 'spec_helper'

module ElFinder
  describe Directory do

    subject { el_directory }

    its(:name)      { should == 'directory' }
    its(:hash)      { should == "r#{root.id}_ZGlyZWN0b3J5" }
    its(:phash)     { should == el_root.hash }
    its(:mime)      { should == 'directory' }
    its(:date)      { should == I18n.l(Time.now) }
    its(:size)      { should == 0 }
    its(:dirs)      { should == 0 }
    its(:read)      { should == 1 }
    its(:write)     { should == 1 }
    its(:locked)    { should == 0 }

    context "with subdirs" do
      before { Fabricate :directory_entry, :parent => directory }
      subject { el_directory(:entry => directory)}

      its(:dirs) { should == 1 }
    end

    describe '#el_hash' do
      subject { el_directory.el_hash }
      its(:keys) { should include('dirs') }
    end
  end
end

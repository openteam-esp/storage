# encoding: utf-8

require 'spec_helper'

module ElFinder
  describe Root do

    subject { el_root }

    its(:name)        { should == 'Root' }
    its(:hash)        { should == "r#{root.id}_Lw" }
    its(:phash)       { should == '' }
    its(:mime)        { should == 'directory' }
    its(:date)        { should == I18n.l(Time.now) }
    its(:size)        { should == 0 }
    its(:dirs)        { should == 0 }
    its(:read)        { should == 1 }
    its(:write)       { should == 1 }
    its(:locked)      { should == 0 }
    its(:volumeid)    { should == "r#{root.id}_"}

    context 'when directory exist'  do
      before { create_directory }

      its(:dirs)      { should == 1 }
    end

    context 'when directory exist'  do
      before { create_file }

      its(:dirs)      { should == 0 }
    end

    context 'initialized with directory' do
      subject  { el_root(directory) }

      its(:name)      { should == 'directory' }
      its(:hash)      { should == "r#{directory.id}_Lw" }
      its(:volumeid)  { should == "r#{directory.id}_" }
    end

  end
end

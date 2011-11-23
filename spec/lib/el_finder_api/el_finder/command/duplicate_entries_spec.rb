# encoding: utf-8

require 'spec_helper'

module ElFinder

  describe Command::DuplicateEntries do
    let(:params)        { {targets: targets} }
    let(:el_entries)    { [el_directory, el_file] }
    let(:targets)       { el_entries.map(&:hash) }
    alias :create_entries :el_entries

    before     { create_entries }

    describe '#result' do
      subject { command.result }
      before  { command.run }

      its(:added) { subject.map(&:name).should == ['directory copy1', 'file copy1.txt'] }
    end

    describe '#run' do
      it { expect{command.run}.to change{root.children.count}.by(2) }
    end

  end

end

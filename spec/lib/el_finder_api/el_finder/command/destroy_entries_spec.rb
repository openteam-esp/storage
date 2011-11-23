# encoding: utf-8

require 'spec_helper'

module ElFinder

  describe Command::DestroyEntries do
    let(:params)        { {targets: targets} }
    let(:el_entries)    { [el_file, el_directory] }
    let(:targets)       { el_entries.map(&:hash) }
    alias :create_entries :el_entries

    before          { create_entries }

    describe '#result' do
      before            { command.run }
      let(:subject)     { command.result }

      its(:removed)     { targets }
    end

    describe '#run' do
      it { expect{command.run}.to change{root.children.count}.by(-2) }
      it { command.run; expect{el_entries.map(&:entry).map(&:reload)}.should raise_error ActiveRecord::RecordNotFound }
    end
  end
end

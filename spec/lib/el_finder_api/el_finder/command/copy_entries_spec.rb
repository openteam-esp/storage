# encoding: utf-8

require 'spec_helper'

module ElFinder

  describe Command::CopyEntries do
    let(:source)        { make_el_directory :name => 'source' }
    let(:destination)   { make_el_directory :name => 'destination' }
    let(:el_entries)    { [el_file(:parent => source.entry), make_el_directory(:parent => source.entry, :name => 'directory')] }
    let(:hashes)        { el_entries.map(&:hash) }

    let(:params)        { {src: source.hash, dst: destination.hash,  targets: hashes, cut: '0'} }

    describe '#run' do
      alias :create_source :source
      alias :create_entries :el_entries
      alias :create_destination :destination

      before            { create_source }
      before            { create_destination }
      before            { create_entries }

      context '(cut: false)' do
        it              { expect{command.run}.to change{destination.entry.children.count}.by(2) }
        it              { expect{command.run}.to_not change{source.entry.children.count} }
        it              { command.run; expect{el_entries.map(&:entry).map(&:reload)}.should_not raise_error }
      end

      context '(cut: true)' do
        alias :old_params :params
        let(:params)    { old_params[:cut] = true; old_params }
        it              { expect{command.run}.to change{destination.entry.children.count}.by(2) }
        it              { expect{command.run}.to change{source.entry.children.count}.by(-2) }
      end
    end

    describe '#result' do
        let(:subject)   { command.result }

        before        { command.run }

        context '(cut: false)' do
          its(:added)   { subject.map(&:name).should == %w[file.txt directory] }
          its(:removed) { should == [] }
        end

        context '(cut: true)' do
          alias :old_params :params
          let(:params)    { old_params[:cut] = true; old_params }

          its(:added)     { subject.map(&:name).should == %w[file.txt directory] }
          its(:removed)   { should == hashes }
        end
    end

  end

end

# encoding: utf-8

require 'spec_helper'

module ElFinder

  describe Command::CreateDirectory do
    let(:params)      { {target: el_root.hash, name: 'directory'} }

    context '(target: root)' do
      it              { expect{command.send(:execute_command)}.to change{root.directories.count}.by(1) }

      describe '#result' do
        subject { command.result }
        before { command.run }

        its(:added)   { should == [root.directories.first] }
      end
    end
  end

end

# encoding: utf-8

require 'spec_helper'

module ElFinder

  describe Command::CreateFile do
    context '(target: root)' do
      let(:params)    { {target: el_root.hash, name: 'file'} }

      it              { expect{command.run}.to change{root.files.count}.by(1) }

      describe '#result' do
        before        { command.run }
        subject       { command.result }

        its(:added)   { should == [root.files.first] }
      end
    end
  end

end

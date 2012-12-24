require 'spec_helper'

module ElFinder

  describe Command::GetDimentions do
    describe '#result' do

      before { command.run }
      subject { command.result }

      context 'target: file' do
        let(:params) { {target: el_file.hash} }
        its(:dim) { should be_nil }
      end

      context 'target: image' do
        let(:params) { {target: el_image.hash} }
        its(:dim) { should == '5x5' }
      end
    end
  end
end

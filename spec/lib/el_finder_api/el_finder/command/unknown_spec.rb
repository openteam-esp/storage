require 'spec_helper'

describe ElFinder::Command::Unknown do
  let(:command) { described_class.new({}) }
  let(:subject) { command.result }
  before        { command.run }
  its(:error)   { should == :errUnknownCmd }
end

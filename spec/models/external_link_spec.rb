require 'spec_helper'

describe ExternalLink do
  it { should validate_presence_of :path }
  it { should validate_presence_of :url }

  describe '#create' do
    subject{ ExternalLink.create! :path => file.full_path, :url => 'some url' }
    its(:entry) { should == file }
  end
end

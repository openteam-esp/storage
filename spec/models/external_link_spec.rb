require 'spec_helper'

describe ExternalLink do
  it { should validate_presence_of :path }
  it { should validate_presence_of :url }

  describe '#create' do
    subject{ ExternalLink.create! :path => file.full_path, :url => 'some url' }
    its(:entry) { should == file }
  end
end
# == Schema Information
#
# Table name: external_links
#
#  id         :integer         not null, primary key
#  entry_id   :integer
#  path       :text
#  url        :text
#  created_at :datetime        not null
#  updated_at :datetime        not null
#


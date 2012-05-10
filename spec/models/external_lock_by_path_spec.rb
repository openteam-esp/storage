require 'spec_helper'

describe ExternalLockByPath do
  it { should validate_presence_of :entry_path }
  it { should validate_presence_of :external_url }

  def create_subject
    ExternalLockByPath.create! :entry_path => file.full_path, :external_url => 'some url'
  end

  describe '#create' do
    subject{ ExternalLockByPath.create! :entry_path => file.full_path, :external_url => 'some url' }
    its(:entry) { should == file }
  end
end
# == Schema Information
#
# Table name: locks
#
#  id            :integer         not null, primary key
#  type          :string(255)
#  entry_id      :integer
#  file_entry_id :integer
#  entry_path    :string(255)
#  entry_url     :string(255)
#  external_url  :string(255)
#  created_at    :datetime        not null
#  updated_at    :datetime        not null
#


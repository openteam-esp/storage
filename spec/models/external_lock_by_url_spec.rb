require 'spec_helper'

describe ExternalLockByUrl do
  it { should validate_presence_of :entry_url }
  it { should validate_presence_of :external_url }

  def create_subject
    ExternalLockByUrl.create! :entry_url => "#{Settings['app.url']}/files/#{file.id}/#{file.name}", :external_url => 'some url'
  end

  describe 'uniqueness of external_url' do
    before { create_subject }
    it { should validate_uniqueness_of(:external_url).scoped_to(:entry_id) }
  end

  describe '#create' do
    subject{ create_subject }
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


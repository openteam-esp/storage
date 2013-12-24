require 'spec_helper'

describe InternalLock do
  it { should validate_presence_of :file_entry }
  context 'uniqueness of file_entry' do
    before { InternalLock.create!({ :file_entry => file, :entry => another_file }, :without_protection => true) }
    it { should validate_uniqueness_of(:file_entry_id).scoped_to(:entry_id) }
  end
  context 'could not links to self' do
    subject { InternalLock.new({ :file_entry => file, :entry => file }, :without_protection => true) }
    it { should_not be_valid }
  end
end

# == Schema Information
#
# Table name: locks
#
#  id            :integer          not null, primary key
#  type          :string(255)
#  entry_id      :integer
#  file_entry_id :integer
#  entry_path    :string(255)
#  entry_url     :string(255)
#  external_url  :string(255)
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#


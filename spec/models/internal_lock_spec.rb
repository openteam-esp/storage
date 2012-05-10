require 'spec_helper'

describe InternalLock do
  it { should validate_presence_of :file_entry }
  context 'uniqueness of file_entry' do
    before { InternalLock.create! :file_entry => file, :entry => another_file }
    it { should validate_uniqueness_of(:file_entry_id).scoped_to(:entry_id) }
  end
  context 'could not links to self' do
    subject { InternalLock.new :file_entry => file, :entry => file }
    it { should_not be_valid }
  end
end

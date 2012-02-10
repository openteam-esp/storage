# encoding: utf-8

require 'spec_helper'

describe RootEntry do
  subject               { root }
  it                    { should_not validate_presence_of :name }
  it                    { should_not validate_presence_of :parent }
  it                    { should_not allow_value(root).for :parent }
  it                    { should_not allow_value(directory).for :parent }
  it                    { should_not allow_value(file).for :parent }
  its(:name)            { should be_nil }
  its(:full_path)       { should be_empty }

  describe '#duplicate' do
    it                  { expect{subject.duplicate}.to raise_exception }
  end
end
# == Schema Information
#
# Table name: entries
#
#  id                  :integer         not null, primary key
#  type                :string(255)
#  name                :string(255)
#  ancestry            :string(255)
#  ancestry_depth      :integer
#  file_uid            :string(255)
#  file_size           :integer
#  file_width          :integer
#  file_height         :integer
#  file_mime_type      :string(255)
#  file_mime_directory :string(255)
#  created_at          :datetime
#  updated_at          :datetime
#


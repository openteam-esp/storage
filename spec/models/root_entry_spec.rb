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

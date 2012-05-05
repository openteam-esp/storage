require 'spec_helper'
require "#{Rails.root}/lib/subscribers/cms_subscriber"

describe CmsSubscriber do
  let(:external_url) { 'http://some.url/to_page#with_file' }
  let(:by_path_params) { {:entry_path => file.full_path, :external_url => external_url} }
  let(:by_url_params) { {:entry_url => file.url, :external_url => external_url} }
  describe '#lock' do
    context 'by path' do
      specify { expect{subject.lock_by_path(by_path_params)}.to change{ExternalLockByPath.count}.by(1) }
    end
    context 'by url' do
      specify { expect{subject.lock_by_url(by_url_params)}.to change{ExternalLockByUrl.count}.by(1) }
    end
  end
  describe '#unlock' do
    context 'by path' do
      before { subject.lock_by_path(by_path_params) }
      specify { expect{subject.unlock_by_path(by_path_params)}.to change{ExternalLockByPath.count}.by(-1) }
    end
    context 'by url' do
      before { subject.lock_by_url(by_url_params) }
      specify { expect{subject.unlock_by_url(by_url_params)}.to change{ExternalLockByUrl.count}.by(-1) }
    end
  end
end

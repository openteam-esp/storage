require 'spec_helper'
require "#{Rails.root}/lib/subscribers/cms_subscriber"

describe CmsSubscriber do
  let(:external_url) { 'http://some.url/to_page#with_file' }
  let(:path_params) { {:entry_path => file.full_path, :external_url => external_url} }
  let(:url_params) { {:entry_url => file.url, :external_url => external_url} }
  describe '#lock' do
    context 'by path' do
      specify { expect{subject.lock_by_path(path_params)}.to change{ExternalLockByPath.count}.by(1) }
      context 'duplicate call' do
        before { subject.lock_by_path(path_params) }
        specify { expect{subject.lock_by_path(path_params)}.to_not change{ExternalLockByPath.count} }
      end
    end
    context 'by url' do
      specify { expect{subject.lock_by_url(url_params)}.to change{ExternalLockByUrl.count}.by(1) }
      context 'duplicate call' do
        before { subject.lock_by_url(url_params) }
        specify { expect{subject.lock_by_url(url_params)}.to_not change{ExternalLockByUrl.count} }
      end
    end
  end
  describe '#unlock' do
    context 'by path' do
      before { subject.lock_by_path(path_params) }
      specify { expect{subject.unlock_by_path(path_params)}.to change{ExternalLockByPath.count}.by(-1) }
    end
    context 'by url' do
      before { subject.lock_by_url(url_params) }
      specify { expect{subject.unlock_by_url(url_params)}.to change{ExternalLockByUrl.count}.by(-1) }
    end
  end
end

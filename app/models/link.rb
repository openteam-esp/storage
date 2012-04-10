class Link < ActiveRecord::Base
  belongs_to :linkable, :polymorphic => true
end
# == Schema Information
#
# Table name: links
#
#  id              :integer         not null, primary key
#  storage_file_id :integer
#  linkable_id     :integer
#  linkable_type   :string(255)
#  created_at      :datetime        not null
#  updated_at      :datetime        not null
#


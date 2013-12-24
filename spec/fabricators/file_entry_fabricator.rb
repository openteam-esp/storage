Fabricator(:file_entry) do
  file    { File.new("#{Rails.root}/spec/fixtures/file.txt") }
  parent  { RootEntry.instance }
end

# == Schema Information
#
# Table name: entries
#
#  id                  :integer          not null, primary key
#  type                :string(255)
#  name                :text
#  ancestry            :string(255)
#  ancestry_depth      :integer
#  file_uid            :string(255)
#  file_size           :integer
#  file_width          :integer
#  file_height         :integer
#  file_mime_type      :string(255)
#  file_mime_directory :string(255)
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#


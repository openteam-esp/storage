require 'spec_helper'

module ElFinder
  describe File do
    subject { el_file }

    its(:name) { should == 'file.txt' }
    its(:hash) { should == "r#{root.id}_ZmlsZS50eHQ" }
    its(:phash) { should == "r#{root.id}_Lw" }
    its(:mime) { should == 'text/plain' }
    its(:date) { should == I18n.l(Time.now) }
    its(:size) { should == 10 }
    its(:read) { should == 1 }
    its(:write) { should == 1 }
    its(:locked) { should == 0 }
    its(:url) { should == "#{Settings['app.url']}/files/#{el_file.entry.id}/#{el_file.name}" }
    its(:attributes) { should_not include('tmb') }
    it { should_not respond_to :dirs }
    # 'bac0d45b625f8d4633435ffbd52ca495.png' - имя файла превьюшки (для картинок). Если файл не имеет превью, но оно может быть создано, поле принимает значение "1"
  end
end

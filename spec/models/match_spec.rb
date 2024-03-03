require 'rails_helper'

RSpec.describe Match, type: :model do
  describe 'relationships' do
    it { should belong_to(:import) }
    it { should have_many(:kills).dependent(:destroy) }
    it do
      should have_one(:cache_report).
        class_name('Cache::Report').dependent(:destroy)
    end
  end
end

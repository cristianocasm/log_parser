require 'rails_helper'

RSpec.describe Cache::Report, type: :model do
  describe 'relationships' do
    it { should belong_to(:match) }
  end

  describe 'validations' do
    it { should validate_presence_of(:stats) }
  end
end

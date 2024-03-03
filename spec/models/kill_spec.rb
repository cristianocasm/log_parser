require 'rails_helper'

RSpec.describe Kill, type: :model do
  describe 'relationships' do
    it { should belong_to(:match) }
  end

  describe 'validations' do
    it { should validate_presence_of(:killer) }
    it { should validate_presence_of(:victim) }
    it { should validate_presence_of(:means) }
  end
end

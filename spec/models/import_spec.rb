require 'rails_helper'

RSpec.describe Import, type: :model do
  describe 'relationships' do
    it { should have_one_attached(:log_file) }
    it { should have_many(:matches).dependent(:destroy) }
  end

  describe 'validations' do
    it { should validate_presence_of(:status) }
    it do
      should validate_inclusion_of(:status).
        in_array(%w[pending parsing parsed error]).
        with_message(/is not a valid status/)
    end

    it 'validates uniqueness of log file' do
      expect(Import).to receive(:file_alreay_imported?).and_return(true)
      import = build(:import)
      expect(import.valid?).to be(false)
      expect(import.errors.messages[:log_file]).
        to include('already imported')
    end
  end

  describe 'hooks' do
    describe 'after_create_commit :parse_log_file' do
      let(:import) { build(:import) }

      it 'invokes LogParserJob' do
        expect(LogParserJob).to receive(:perform_later).with(import)
        import.save!
      end
    end
  end
end

require 'rails_helper'

RSpec.describe Parser do
  let(:import) do
    allow_any_instance_of(Import).to receive(:parse_log_file)
    create(:import)
  end

  subject { described_class.call(import) }

  before do
    log_file = double
    expect(log_file).to receive(:open).and_yield((File.open(
      Rails.root.join('spec', 'fixtures', 'log.txt')
    )))

    allow(import).to receive(:log_file).and_return(log_file)
  end

  it 'persists matches' do
    expect { subject }.to change(Match, :count).by(2)
  end

  it 'persists kills' do
    expect { subject }.to change(Kill, :count).by(11)
  end

  it 'creates cache for report' do
    expect { subject }.to change(Cache::Report, :count).by(2)
    expect(Cache::Report.first.stats).to eq({
      "kills"=>{"Isgalamido"=>0},
      "players"=>["Isgalamido"],
      "total_kills"=>0,
      "kills_by_means"=>{}
    })
    expect(Cache::Report.last.stats).to eq({
      "kills"=>{"Mocinha"=>0, "Isgalamido"=>-5, "Dono da Bola"=>0},
      "players"=>["Isgalamido", "Dono da Bola", "Mocinha"],
      "total_kills"=>11,
      "kills_by_means"=>{"MOD_FALLING"=>1, "MOD_TRIGGER_HURT"=>7, "MOD_ROCKET_SPLASH"=>3}
    })
  end
end

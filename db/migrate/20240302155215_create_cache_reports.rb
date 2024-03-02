class CreateCacheReports < ActiveRecord::Migration[7.1]
  def change
    create_table :cache_reports do |t|
      t.references :match, null: false, foreign_key: true
      t.jsonb :stats, null: false, default: '{}'

      t.timestamps
    end
  end
end

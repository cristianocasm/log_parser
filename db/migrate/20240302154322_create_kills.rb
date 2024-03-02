class CreateKills < ActiveRecord::Migration[7.1]
  def change
    create_table :kills do |t|
      t.references :match, null: false, foreign_key: true
      t.string :killer
      t.string :victim
      t.string :means, limit: 40

      t.timestamps
    end
  end
end

class CreateKills < ActiveRecord::Migration[7.1]
  def change
    create_table :kills do |t|
      t.references :match, null: false, foreign_key: true
      t.string :killer, null: false
      t.string :victim, null: false
      t.string :means, limit: 40

      t.timestamps
    end
  end
end

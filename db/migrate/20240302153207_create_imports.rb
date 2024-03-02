class CreateImports < ActiveRecord::Migration[7.1]
  def change
    create_table :imports do |t|
      t.string :status, limit: 7, null: false

      t.timestamps
    end
  end
end

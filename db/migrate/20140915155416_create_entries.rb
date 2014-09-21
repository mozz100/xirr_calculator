class CreateEntries < ActiveRecord::Migration
  def change
    create_table :entries do |t|
      t.references :account, index: true, null: false
      t.integer :entrytype, null: false
      t.decimal :value, null: false, precision: 16, scale: 2

      t.timestamps
    end
  end
end

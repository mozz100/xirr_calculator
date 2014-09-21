class CreateAccounts < ActiveRecord::Migration
  def change
    create_table :accounts do |t|
      t.string :code, null: false
      t.string :name, null: false

      t.timestamps
    end
  end
end

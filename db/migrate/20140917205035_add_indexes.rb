class AddIndexes < ActiveRecord::Migration
  def change
    add_index :entries, :entrydate
    add_index :entries, :entrytype
  end
end

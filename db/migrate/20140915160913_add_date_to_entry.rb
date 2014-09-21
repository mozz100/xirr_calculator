class AddDateToEntry < ActiveRecord::Migration
  def change
    add_column :entries, :entrydate, :date
  end
end

class UpdatePeople < ActiveRecord::Migration
  def change
    change_table :people do |t|
      t.column :gender, :varchar
      t.column :parent_id1, :integer
      t.column :parent_id2, :integer
    end
  end
end

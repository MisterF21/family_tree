class CreateParentsChildren < ActiveRecord::Migration
  def change
    create_table :parents_children do |t|

      t.column :parent1_id, :integer
      t.column :parent2_id, :integer
      t.column :child_id, :integer

    end
  end
end

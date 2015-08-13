class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :name
      t.integer :type_id
      t.integer :parent_id

      t.timestamps null: false
    end
  end
end

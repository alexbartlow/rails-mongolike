class CreateDbObjects < ActiveRecord::Migration
  def change
    create_table :db_objects, id: :uuid do |t|
      t.json 'payload'
      t.uuid :parent_id
      t.timestamps
    end

    add_index :db_objects, :parent_id
  end
end

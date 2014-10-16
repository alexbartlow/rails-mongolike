class CreateObjectLinks < ActiveRecord::Migration
  def change
    create_table :object_links, id: false do |t|
      t.string :name, :limit => 40, null: false
      t.uuid :db_object_id
      t.timestamps
    end
    add_index :object_links, :name, :unique => true
  end
end

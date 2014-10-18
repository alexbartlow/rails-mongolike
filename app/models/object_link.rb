class ObjectLink < ActiveRecord::Base
  self.primary_key = "name"
  default_scope { eager_load(:db_object) }

  def payload
    db_object.payload.merge("id" => db_object.id, "_name" => self.name)
  end

  class DbObject < ActiveRecord::Base
    self.table_name = "db_objects"
    has_one :object_link
  end

  def self.new_object(name, id, payload)
    dbo = ObjectLink::DbObject.create(payload: payload, id: id)
    ObjectLink.create(db_object_id: dbo.id, name: name)
  end

  def update(new_payload, new_id=SecureRandom.uuid)
    self.update_attributes(db_object: DbObject.create(payload: new_payload, id: new_id))
  end

  belongs_to :db_object, class_name: "ObjectLink::DbObject"
end

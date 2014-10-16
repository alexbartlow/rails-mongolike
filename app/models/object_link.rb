class ObjectLink < ActiveRecord::Base
  self.primary_key = "name"
  belongs_to :db_object
  default_scope { includes(:db_object) }

  def payload
    db_object.payload.merge("id" => db_object.id)
  end
end

class DbObject < ActiveRecord::Base
  has_one :object_link
end

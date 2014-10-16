require 'test_helper'

class ObjectsControllerTest < ActionController::TestCase
  setup do
    ObjectLink.delete_all
    DbObject.delete_all
    @object = DbObject.create(payload: {name: "User One"})
    @one = ObjectLink.create(name: "users/one", db_object_id: @object.id)
  end

  test "get object" do
    get :show, id: "users/one"

    assert_equal response.body, @one.payload.to_json
  end

  test "post object" do
    post :create, {
      payload: {
        name: "User Two"
      },
      name: "users/two",
      uuid: SecureRandom.uuid
    }
    assert response.success?
    last = ObjectLink.last
    assert_equal last.name, "users/two"
  end

  test "put object with old id" do
    put :update, {
      payload: {
        name: "New User One"
      },
      id: "users/one",
      old_id: @object.id
    }

    assert response.success?
    assert_equal ObjectLink.find("users/one").payload["name"], "New User One"
  end

  test "put object with wrong id" do
    put :update, {
      payload: {
        name: "New User One"
      },
      id: "users/one",
      old_id: SecureRandom.uuid
    }
    assert !response.success?
  end

  test "delete" do
    delete :destroy, id: "users/one"

    assert_nil ObjectLink.find_by_name("users/one")
  end
end

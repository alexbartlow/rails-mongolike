require 'test_helper'

class ObjectsControllerTest < ActionController::TestCase
  setup do
    @one = ObjectLink.new_object("users/one", SecureRandom.uuid, {fullName: "User One"})
    @object = @one.db_object
  end

  test "get index" do
    get :index
    assert_equal response.body, [@one.payload].to_json
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
      id: "users/two",
      uuid: SecureRandom.uuid
    }
    assert response.success?
    last = ObjectLink.last
    assert_equal last.name, "users/two"
  end

  test "put object with old id" do
    new_id = SecureRandom.uuid
    put :update, {
      payload: {
        fullName: "New User One"
      },
      id: "users/one",
      old_id: @object.id,
      uuid: new_id
    }

    assert response.success?
    assert_equal ObjectLink.find("users/one").payload["fullName"], "New User One"
    assert_equal ObjectLink.find("users/one").payload["id"], new_id
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
    delete :destroy, id: "users/one", old_id: @object.id
    ole = ObjectLink.find_by_name("users/one").payload
    assert_nil ole["fullName"]
    assert_equal true, ole["_deleted"]
  end
end

require 'test_helper'


class UserSerializerTest < ActiveSupport::TestCase
  test "serializer embeds the inner types" do
    child_type = Type.create(name: "child")
    parent_type = Type.create(name: "parent")

    parent = User.create(name: "The Parent", type: parent_type)
    child1 = User.create(name: "The child", type: child_type, parent: parent)

    result = UserSerializer.new(child1).as_json

    expected_result = {
      "user"=>{
        :name=>"The child",
        :id=>child1.id,
        "parent_id"=>parent.id,
        "type_id"=>child_type.id
      },
      "types"=>[
        {
          :name=>"parent",
          :id=>parent_type.id
        },
        {
          :name=>"child",
          :id=>child_type.id
        }
      ],
      "parents"=>[
        {
          :name=>"The Parent",
          :id=>parent.id,
          "parent_id"=>nil,
          "type_id"=>parent_type.id
        }
      ]
    }

    assert_equal(expected_result, result)
  end
end

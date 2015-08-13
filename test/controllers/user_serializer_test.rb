require 'test_helper'

class TypeSerializer < ActiveModel::Serializer
  attributes :name, :id
end

class UserSerializer < ActiveModel::Serializer
  attributes :name, :id

  has_one :type, serializer: TypeSerializer, embed: :ids, include: true
  has_one :parent, serializer: UserSerializer, embed: :ids, include: true
end

class UserSerializerTest < ActiveSupport::TestCase
  test "serializer embeds the inner types" do
    child_type = Type.new(name: "child")
    child_type.save!

    parent_type = Type.new(name: "parent")
    parent_type.save!

    parent = User.new(name: "The Parent", type: parent_type)
    parent.save!
    child1 = User.new(name: "The child", type: child_type, parent: parent)
    child1.save!

    serializer = UserSerializer.new(child1)

    expected_result = {
      "user"=>{
        :name=>"The child",
        :id=>child1.id,
        "parent_id"=>parent.id,
        "type_id"=>child_type.id
      },
      "types"=>[
        {
          :name=>"child",
          :id=>child_type.id
        },
        {
          :name=>"parent",
          :id=>parent_type.id
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

    assert_equal(expected_result, serializer.as_json)
  end
end

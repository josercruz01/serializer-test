class UserSerializer < ActiveModel::Serializer
  attributes :name, :id

  has_one :type, serializer: TypeSerializer, embed: :ids, include: true
  has_one :parent, serializer: UserSerializer, embed: :ids, include: true
end

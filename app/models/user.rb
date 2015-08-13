class User < ActiveRecord::Base
  belongs_to :type
  belongs_to :parent, class_name: "User", foreign_key: "parent_id"
end

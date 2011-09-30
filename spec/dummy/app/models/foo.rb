class Foo < ActiveRecord::Base
  attr_accessor :require_validation
  belongs_to :foo_relation
  validates_presence_of :foo_relation_id, :if => :require_validation
end

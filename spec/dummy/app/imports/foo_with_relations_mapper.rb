class FooWithRelationsMapper < Importable::Mapper
  foo_relation_id_maps_from :relation

  def map_row(row)

    foo = Foo.new
    foo.require_validation = true

    if row.relation == 'exists'
      foo.foo_relation_id = 1
    end

    foo
  end
end

class FooRequiredParamResourceMapper < Importable::Mapper
  require_param :foo_id, "You must choose a foo!"

  def map_row(row)
    Foo.new(row)
  end
end

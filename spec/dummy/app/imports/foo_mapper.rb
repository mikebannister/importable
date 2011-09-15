class FooMapper < Importable::Mapper
  def map_row(row)
    Foo.new(row)
  end
end

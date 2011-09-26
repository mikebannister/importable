class FooResourceMapper < Importable::Mapper
  def map_row(raw_row)
    row = {
      foobar_date: raw_row.foo_date
    }

    Foo.new(row)
  end
end

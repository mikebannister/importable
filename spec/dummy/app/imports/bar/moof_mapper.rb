module Bar
  class MoofMapper < Importable::Mapper
    def map_row(row)
      Foo.new(row)
    end
  end
end

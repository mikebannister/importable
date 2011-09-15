class FooRequiredFieldMapper < Importable::Mapper
  def map_row(row)
    FooRequiredField.new(row)
  end
end

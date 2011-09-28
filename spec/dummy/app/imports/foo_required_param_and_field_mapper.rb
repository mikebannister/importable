class FooRequiredParamAndFieldMapper < Importable::Mapper
  require_param :foo_id, "You must choose a foo!"

  def map_row(row)
    FooRequiredField.new(row)
  end
end

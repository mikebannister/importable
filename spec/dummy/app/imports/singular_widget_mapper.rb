class SingularWidgetMapper < Importable::Mapper
  def map_row(row)
    Object.new(row)
  end
end

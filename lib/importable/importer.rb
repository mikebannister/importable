module Importable
  class Importer
    include Validatable
    include ImportLifecycle
  end
end

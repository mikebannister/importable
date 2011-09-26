module Importable
  class FooImporter < Importer
    def rows
      []
    end
    
    def fake_valid?
      true
    end
  end
end

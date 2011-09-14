module Importable
  class Engine < Rails::Engine
    isolate_namespace Importable
  end
end

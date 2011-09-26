class Importable::Row < Hash
  def initialize(data={})
    for k,v in data
      self[k.to_sym] = v
    end
    
    create_case_insensitive_lookup!
  end

  def method_missing(sym, *args, &block)
    key = @case_insensitive_lookup[sym.to_s.downcase.to_sym]
    self[key]
  end
  
  class << self
    def from_resource(resource)
      self.new(resource.attributes)
    end

    def from_hash(hash)
      self.new(hash)
    end
  end

  private
  
  def create_case_insensitive_lookup!
    @case_insensitive_lookup = {}
    for k,v in self
      @case_insensitive_lookup[k.to_s] = k
      @case_insensitive_lookup[k.to_s.downcase.to_sym] = k
    end
  end
end

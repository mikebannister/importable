class Importable::Row < Hash
  def initialize(hash={})
    if hash
      for k,v in hash
        self[k.to_sym] = v
      end
    end
    
    create_case_insensitive_mapper!
  end

  def method_missing(sym, *args, &block)
    key = @case_insensitive_mapper[sym.to_s.downcase.to_sym]
    self[key]
  end
  
  private
  
  def create_case_insensitive_mapper!
    @case_insensitive_mapper = {}
    for k,v in self
      @case_insensitive_mapper[k.to_s] = k
      @case_insensitive_mapper[k.to_s.downcase.to_sym] = k
    end
  end
end

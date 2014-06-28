class Env < Hash
  def initialize(names, values, outer = nil)
    update(Hash[names.zip(values)])
    @outer = outer
  end

  def find(name)
    if has_key?(name)
      self
    else
      @outer.find(name) if @outer
    end
  end
end
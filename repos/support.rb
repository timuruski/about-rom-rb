module Repository
  def rom
    @rom ||= ROM.env
  end

  def f(*args)
    Functions[*args]
  end
end

module F
  extend Transproc::Registry

  import Transproc::ArrayTransformations
  import Transproc::HashTransformations
end

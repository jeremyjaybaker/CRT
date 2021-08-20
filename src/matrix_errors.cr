module MatrixErrors
  class MismatchedElementCount < Exception
    def initialize(m1 : Int32, m2 : Int32)
      super "Expected initialization with element count <=#{m1} but got #{m2}."
    end
  end

  class MismatchedDimensions < Exception
    def initialize(m1 : Array(Int32), m2 : Array(Int32))
      super "Expected matrix of dimension #{m1} but got #{m2}."
    end
  end

  class CannotMultiply < Exception
    def initialize(m1 : Array(Int32), m2 : Array(Int32))
      super "Expected matrices of dimension mxn*qxp where n=q, but got #{m1}*#{m2}."
    end
  end

  class DimensionOutOfRange < Exception
    def initialize(type : String, dim : Int32)
      super "Given #{type} value #{dim} exceeds dimensions for this matrix."
    end
  end

  class NotSquare < Exception
    def initialize(size : Array(Int32))
      super "Matrix must be square but given #{size}."
    end
  end

  class NotInvertible < Exception
    def initialize
      super "Matrix is not invertible"
    end
  end
end

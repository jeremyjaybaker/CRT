# A collection of error classes that provide dev-friendly messages
# for all the things that can go wrong with matrices.
module CRT
  module MatrixErrors
    # Only really used when the Matrix splat initializer method when an
    # incorrect number of elements is given relative to the mxn value.
    class MismatchedElementCount < Exception
      def initialize(m1 : Int32, m2 : Int32)
        super "Expected initialization with element count <=#{m1} but got #{m2}."
      end
    end

    # Thrown when matrices need to be of equal dimension to be operated on.
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

    # Thrown when accessing a non-existant index for a matrix. Currently
    # only thrown during submatrix calculation.
    class DimensionOutOfRange < Exception
      def initialize(m : Float64, n : Float64, mat : CRT::Matrix)
        super "Element index #{m}x#{n} exceeds dimensions for matrix #{mat.size}."
      end
    end

    class NotSquare < Exception
      def initialize(size : Array(Int32))
        super "Matrix must be square but given #{size}."
      end
    end

    # To check invertibility before calling #inverse, use the #invertible? method.
    # #inverse will always raise this exception if non-invertible.
    class NotInvertible < Exception
      def initialize
        super "Matrix is not invertible"
      end
    end
  end
end

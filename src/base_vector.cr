# BaseVector is used as a superclass to make Point and Vector definitions
# more convenient. The two classes are almost identical except for their
# value of #w (0 for vector, 1 for point) which makes the linear algebra
# calculations more smooth.
module CRT
  abstract struct BaseVector
    getter matrix : CRT::Matrix

    class InvalidMatrix < Exception
      def initialize(mat : CRT::Matrix)
        super "BaseVector cannot be created with #{mat.size} of #{mat.to_a}."
      end
    end

    # Best way to initialize from hard-coded values
    def initialize(x : Float64, y : Float64, z : Float64)
      @matrix = CRT::Matrix.new(4,1, x, y, z, w)
    end

    # Best way to initialize when a matrix already exists
    def initialize(@matrix : Matrix)
      raise InvalidMatrix.new(@matrix) unless @matrix.size == [4,1] && @matrix[3][0] == w
    end

    def x
      @matrix[0][0]
    end

    def y
      @matrix[0][1]
    end

    def z
      @matrix[0][2]
    end

    def to_a
      @matrix.to_a
    end

    def w
      raise "Must be defined in child"
    end

    def -
      self.class.new(@matrix * -1)
    end

    def /(d : Float64)
      self.class.new(@matrix / d)
    end

    def *(d : Float64)
      self.class.new(@matrix * d)
    end

    def +(vec : BaseVector)
      self.class.new(@matrix + vec.matrix)
    end

    def -(vec : BaseVector)
      self.class.new(@matrix - vec.matrix)
    end

    def ==(b : BaseVector)
      @matrix == b.matrix
    end

    def translate(x : Float64, y : Float64, z : Float64)
      arr = [
        [1.0, 0.0, 0.0, x],
        [0.0, 1.0, 0.0, y],
        [0.0, 0.0, 1.0, z],
        [0.0, 0.0, 0.0, 1.0]
      ]
      self.class.new(CRT::Matrix.new(arr) * self)
    end

    def scale(x : Float64, y : Float64, z : Float64)
      arr = [
        [x,   0.0, 0.0, 0.0],
        [0.0, y,   0.0, 0.0],
        [0.0, 0.0, z,   0.0],
        [0.0, 0.0, 0.0, 1.0]
      ]
      self.class.new(CRT::Matrix.new(arr) * self)
    end

    def rotate_x(rad : Float64)
      sin,cos = trig_vals(rad)
      arr = [
        [1.0, 0.0, 0.0,    0.0],
        [0.0, cos, sin*-1, 0.0],
        [0.0, sin, cos,    0.0],
        [0.0, 0.0, 0.0,    1.0]
      ]
      self.class.new(CRT::Matrix.new(arr) * self)
    end

    def rotate_y(rad : Float64)
      sin,cos = trig_vals(rad)
      arr = [
        [cos,    0.0, sin, 0.0],
        [0.0,    1.0, 0.0, 0.0],
        [sin*-1, 0.0, cos, 0.0],
        [0.0,    0.0, 0.0, 1.0]
      ]
      self.class.new(CRT::Matrix.new(arr) * self)
    end

    def rotate_z(rad : Float64)
      sin,cos = trig_vals(rad)
      arr = [
        [cos, sin*-1, 0.0, 0.0],
        [sin, cos,    0.0, 0.0],
        [0.0, 0.0,    1.0, 0.0],
        [0.0, 0.0,    0.0, 1.0]
      ]
      self.class.new(CRT::Matrix.new(arr) * self)
    end

    def shear(a : Float64,       b : Float64 = 0.0, c : Float64 = 0.0,
              d : Float64 = 0.0, e : Float64 = 0.0, f : Float64 = 0.0)
      arr = [
        [1.0, a,   b,   0.0],
        [c,   1.0, d,   0.0],
        [e,   f,   1.0, 0.0],
        [0.0, 0.0, 0.0, 1.0]
      ]
      self.class.new(CRT::Matrix.new(arr) * self)
    end

    private def trig_vals(rad : Float64)
      [Math.sin(rad), Math.cos(rad)]
    end
  end
end

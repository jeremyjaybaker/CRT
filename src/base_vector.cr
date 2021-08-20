# Superclass used to define basic behaviors for Point and Vector.
# TODO: This is not a great name.
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

    def +(vec : Vector)
      self.class.new(@matrix + vec.matrix)
    end

    def -(vec : Vector)
      self.class.new(@matrix - vec.matrix)
    end

    def ==(b : BaseVector)
      @matrix == b.matrix
    end

    def translate(x : Float64, y : Float64, z : Float64)
      newm = Matrix.identity(4,4)
      newm[0][3] = x
      newm[1][3] = y
      newm[2][3] = z
      self.class.new(newm * @matrix)
    end

    def scale(x : Float64, y : Float64, z : Float64)
      newm = CRT::Matrix.identity(4,4)
      newm[0][0] = x
      newm[1][1] = y
      newm[2][2] = z
      self.class.new(newm * @matrix)
    end

    def rotate_x(rad : Float64)
      multiply_by_new do |newm|
        sin_val = Math.sin(rad)
        newm[1][1] = newm[2][2] = Math.cos(rad)
        newm[1][2] = sin_val * -1
        newm[2][1] = sin_val
      end
    end

    def rotate_y(rad : Float64)
      multiply_by_new do |newm|
        sin_val = Math.sin(rad)
        newm[0][0] = newm[2][2] = Math.cos(rad)
        newm[2][0] = sin_val * -1
        newm[0][2] = sin_val
      end
    end

    def rotate_z(rad : Float64)
      multiply_by_new do |newm|
        sin_val = Math.sin(rad)
        newm[0][0] = newm[1][1] = Math.cos(rad)
        newm[0][1] = sin_val * -1
        newm[1][0] = sin_val
      end
    end

    private def multiply_by_new(&)
      newm = CRT::Matrix.identity(4,4)
      yield newm
      self.class.new(newm * self)
    end
  end
end

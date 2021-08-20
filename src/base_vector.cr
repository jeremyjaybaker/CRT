# Superclass used to define basic behaviors for Point and Vector.
# TODO: This is not a great name.
module CRT
  abstract struct BaseVector
    getter matrix : CRT::Matrix

    # Best way to initialize from hard-coded values
    def initialize(x : Float64, y : Float64, z : Float64)
      @matrix = CRT::Matrix.new(4,1, x, y, z, w)
    end

    # Best way to initialize when a matrix already exists
    def initialize(@matrix : Matrix)
      raise "Invalid" unless @matrix.size == [4,1]
      raise "Invalid" unless @matrix[3][0] == w
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
  end
end

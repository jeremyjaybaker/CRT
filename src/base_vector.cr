module CRT
  # BaseVector is used as a superclass to make Point and Vector definitions
  # more convenient. The two classes are mostly identical except for their
  # value of #w (0 for vector, 1 for point) which makes the linear algebra
  # calculations more smooth. Vector also has a few more calculations in it
  # like #cross and #dot, but majority functionality is still shared.
  abstract struct BaseVector
    class InvalidMatrix < Exception
      def initialize(mat : CRT::Matrix)
        super "Cannot initialize vector-based class with matrix #{mat}."
      end
    end

    # Best way to initialize from hard-coded values
    def initialize(x : Float64, y : Float64, z : Float64)
      @_matrix = CRT::Matrix.new(4,1, x, y, z, w)
    end

    # Best way to initialize when a matrix already exists
    def initialize(@_matrix : Matrix)
      unless @_matrix.size == [4,1] && @_matrix[3][0] == w
        raise InvalidMatrix.new(@_matrix)
      end
    end

    # Makes either a new Point or a Vector depending on the value
    # of w being passed in. This makes it very easy to just perform
    # math operations and get the expected class in return.
    #
    # NOTE: this factory returns union type of Base+ and will likely
    # require some conversions during operations. This isn't as
    # elegant as I'd like it to be, but not sure what to do about that
    # for now. This is also bad design as the parent should not have
    # any concept of it's child classes.
    #
    # Example of the problem:
    # ```
    # p1 = CRT::Point.new(1,1,1)
    # p2 = CRT::Point.new(2,2,2)
    # foo = p1 - p2
    # typeof(foo) #=> BaseVector+ because it's a union type
    # foo.class   #=> CRT::Vector
    #
    # def do_thing(v : CRT::Vector)
    #   puts v
    # end
    #
    # do_thing(foo)                 #=> raises exception
    # do_thing(foo.as(CRT::Vector)) #=> works as expected, but verbose
    # ```
    def self.from(mat : Matrix)
      mat_w = mat[3][0]
      if mat_w == 0
        CRT::Vector.new(mat)
      elsif mat_w == 1
        CRT::Point.new(mat)
      else
        raise InvalidMatrix.new(mat)
      end
    end

    def x
      @_matrix[0][0]
    end

    def y
      @_matrix[1][0]
    end

    def z
      @_matrix[2][0]
    end

    def w
      raise "Must be defined in child"
    end

    def to_a
      @_matrix.to_a
    end

    def to_matrix
      @_matrix
    end

    def -
      self.class.new(x*-1, y*-1, z*-1)
    end

    def /(d : Float64)
      self.class.from(@_matrix / d)
    end

    def *(d : Float64)
      self.class.from(@_matrix * d)
    end

    def +(vec : BaseVector)
      self.class.from(@_matrix + vec.to_matrix)
    end

    def -(vec : BaseVector)
      self.class.from(@_matrix - vec.to_matrix)
    end

    def ==(b : BaseVector)
      @_matrix == b.to_matrix
    end

    def translate(x : Float64, y : Float64, z : Float64)
      self.class.from(Matrices.translation(x,y,z) * self)
    end

    def scale(x : Float64, y : Float64, z : Float64)
      self.class.from(Matrices.scale(x,y,z) * self)
    end

    def rotate_x(rad : Float64)
      self.class.from(Matrices.rotation_x(rad) * self)
    end

    def rotate_y(rad : Float64)
      self.class.from(Matrices.rotation_y(rad) * self)
    end

    def rotate_z(rad : Float64)
      self.class.from(Matrices.rotation_z(rad) * self)
    end

    def shear(a : Float64,       b : Float64 = 0.0, c : Float64 = 0.0,
              d : Float64 = 0.0, e : Float64 = 0.0, f : Float64 = 0.0)
      self.class.from(Matrices.shear(a,b,c,d,e,f) * self)
    end
  end
end

# Representation of a float64-based matrix of arbitrary dimensions.
#
# TODO: There's a lot of initializing a matrix with 0, then setting values.
# Maybe a source of performance bottlenecks?
module CRT
  struct Matrix
    getter m, n, _values

    # Easiest way to make a simple matrix with hard-coded values.
    def initialize(@m : Int32, @n : Int32, *elements)
      initialize(@m, @n, elements.to_a.map(&.to_f))
    end

    # Creates a matrix of all 0s with the given dimensions.
    def initialize(@m : Int32, @n : Int32)
      initialize(@m, @n, [] of Float64)
    end

    # Usually used under the hood by the initializer with the splat call.
    # TODO: Would be nice to have StaticArray used. There should be performance
    # benefits from StaticArray I think?
    def initialize(@m : Int32, @n : Int32, elements : Array(Float64))
      if @m*@n < elements.size
        raise MatrixErrors::MismatchedElementCount.new(@m*@n, elements.size)
      end

      # TODO: is this the best way to init a matrix? seems verbose
      @_values = Array(Array(Float64)).new
      @m.times{ |i| @_values << Array(Float64).new }

      traverse do |i,j|
        index = (i * @n) + j
        if elements[index]?
          @_values[i] << elements[index]
        else
          @_values[i] << 0.0
        end
      end
    end

    def initialize(@_values : Array(Array(Float64)))
      @m = @_values.size
      @n = @_values[0].size
    end

    def self.identity(m : Int32, n : Int32)
      id = Matrix.new(m,n)
      id.traverse{ |i,j| id[i][j] = 1 if i == j }
      id
    end

    def *(sp : BaseVector)
      self * sp.matrix
    end

    def to_a
      @_values.flatten
    end

    def size
      [@m, @n]
    end

    def [](key)
      @_values[key]
    end

    def square?
      @m == @n
    end

    def clone
      Matrix.new(@_values.clone)
    end

    def det
      @det ||= rec_det(self).as Float64
    end

    def invertible?
      det != 0.0
    end

    def +(m : Matrix)
      raise MatrixErrors::MismatchedDimensions.new(size,m.size) unless size == m.size
      make_new do |i,j,newmat|
        newmat[i][j] = @_values[i][j] + m[i][j]
      end
    end

    def -(m : Matrix)
      raise MatrixErrors::MismatchedDimensions.new(size,m.size) unless size == m.size
      make_new do |i,j,newmat|
        newmat[i][j] = @_values[i][j] - m[i][j]
      end
    end

    def *(mat : Matrix)
      raise MatrixErrors::CannotMultiply.new(size,mat.size) unless @n == mat.m
      make_new @m, mat.n do |i,j,newmat|
        newmat[i][j] = @n.times.map do |k|
          @_values[i][k] * mat[k][j]
        end.sum
      end
    end

    def *(d : Float64)
      make_new do |i,j,newmat|
        newmat[i][j] = @_values[i][j] * d
      end
    end

    def /(d : Float64)
      make_new do |i,j,newmat|
        newmat[i][j] = @_values[i][j] / d
      end
    end

    def ==(mat : Matrix)
      return false if mat.size != size
      traverse do |i,j|
        return false unless CRT.equal? @_values[i][j], mat[i][j]
      end
      true
    end

    # Remove the given row and col indices from the matrix
    def submatrix(row : Int32, col : Int32)
      raise MatrixErrors::DimensionOutOfRange.new("row", row) if row > @m
      raise MatrixErrors::DimensionOutOfRange.new("col", col) if col > @n

      elements = [] of Float64
      traverse{ |i,j| elements << @_values[i][j] unless i == row || j == col }
      Matrix.new(@m - 1, @n - 1, elements)
    end

    # Cofactor matrix for the given matrix. If size is 2x2, a copy of the
    # caller is returned.
    def cofactors
      if size == [2,2]
        clone
      else
        make_new do |i,j,newmat|
          newmat[i][j] = -1**(i+j) * rec_det(submatrix(i,j))
        end
      end
    end

    def inverse
      raise MatrixErrors::NotInvertible.new unless invertible?
      cofactors.transpose / det
    end

    def transpose
      make_new @n, @m do |i,j,newmat|
        newmat[i][j] = @_values[j][i]
      end
    end

    # Simple index interation used to iterate over the set
    # of all i,j matrix elements.
    def traverse(&)
      @m.times do |i|
        @n.times do |j|
          yield i,j
        end
      end
    end

    # Det implementation that allows recursion for smaller submatrices if
    # a size larger than 2x2 is used. This is a support method for the public
    # method #det.
    private def rec_det(mat : Matrix)
      raise MatrixErrors::NotSquare.new(mat.size) unless mat.square?

      if mat.size == [2,2]
        mat[0][0] * mat[1][1] - mat[0][1] * mat[1][0]
      else
        mat.n.times.map do |j|
          # Arbitrarily choosing row 0 to calculate det
          mat[0][j] * -1**j * rec_det(mat.submatrix(0,j)).as Float64
        end.sum
      end
    end

    # Helper method used to construct a new matrix based on values
    # in the current matrix.
    #
    # Usually used like
    # ```
    # make_new do |i,j,val,newm|
    #   newm[i][j] = ...some expression or val transform...
    # end```
    private def make_new(m = @m, n = @n, &)
      newmat = Matrix.new(m,n)
      newmat.traverse do |i,j|
        yield i,j,newmat
      end
      newmat
    end
  end
end

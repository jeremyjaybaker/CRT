module CRT
  struct Sphere
    getter transform : CRT::Matrix

    def initialize(radius : Float64 = 0.0)
      if radius > 0
        @transform = CRT::Matrices.scale(radius,radius,radius)
      else
        @transform = Matrix.identity(4,4)
      end
    end
  end
end

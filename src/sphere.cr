module CRT
  struct Sphere
    getter radius : Float64
    property transform : CRT::Matrix

    def initialize(@radius : Float64 = 1.0)
      @transform = Matrix.identity(4,4)
    end
  end
end

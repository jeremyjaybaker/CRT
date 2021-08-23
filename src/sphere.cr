module CRT
  struct Sphere
    getter radius : Float64, position : CRT::Point
    property transform : CRT::Matrix

    def initialize(@radius : Float64, @position : CRT::Point)
      @transform = Matrix.identity(4,4)
    end
  end
end

module CRT
  struct Vector < BaseVector
    def w
      0
    end

    def unit?
      magnitude == 1.0
    end

    def magnitude
      @mag ||= Math.sqrt(x**2 + y**2 + z**2).as Float64
    end

    # Reflect self across the axis defined by the given vector
    def reflect(v : Vector) : CRT::Vector
      (self - v * 2 * dot(v)).as(CRT::Vector)
    end

    def normal : Vector
      self.class.new(x/magnitude, y/magnitude, z/magnitude)
    end

    def dot(v : Vector) : Float64
      x*v.x + y*v.y + z*v.z
    end

    def cross(v : Vector)
      Vector.new(
        y*v.z - z*v.y,
        z*v.x - x*v.z,
        x*v.y - y*v.x
      )
    end
  end
end

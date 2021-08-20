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

    def normal
      self.class.new(x/magnitude, y/magnitude, z/magnitude)
    end

    def dot(v : Vector)
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

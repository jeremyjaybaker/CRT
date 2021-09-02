module CRT
  struct Sphere
    include Transform
    getter transform : CRT::Matrix,
      material : CRT::Material

    def initialize(radius : Float64 = 1.0, @material = CRT::Material.new)
      @transform = Matrices.scale(radius,radius,radius)
    end

    def initialize(@transform : CRT::Matrix, @material = CRT::Material.new)
    end

    def normal(p : CRT::Point)
      # Given point is world space:
      # obj_space = transform^-1 * world_space
      obj_p = CRT::Point.new(@transform.inverse * p)
      obj_norm = obj_p - CRT::Point.new(0,0,0)
      world_norm = @transform.inverse.transpose * obj_norm
      CRT::Vector.coerce(world_norm).normal
    end

    def normal(x : Float64, y : Float64, z : Float64)
      normal(CRT::Point.new(x,y,z))
    end

    private def transform(mat)
      self.class.new(@transform * mat, @material)
    end
  end
end

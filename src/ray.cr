module CRT
  struct Ray
    getter origin : CRT::Point, path : CRT::Vector

    def initialize(@origin : CRT::Point, @path : CRT::Vector)
    end

    def self.hit(s : Array(Intersection)) : (Intersection | Nil)
      positives = s.select{ |i| i.t > 0 }
      positives.any? ? positives.min_by{ |i| i.t } : nil
    end

    def at(t : Float64)
      path * t + origin
    end

    # Applies the transform matrix to the ray
    def transform(mat : Matrix)
      Ray.new(
        CRT::Point.new(mat * origin),
        CRT::Vector.new(mat * path))
    end

    # TODO: document steps
    def intersections(s : CRT::Sphere)
      # Applies the transform to the ray instead of the sphere so that we can
      # always treat the sphere as existing at the origin.
      ray2 = transform(s.transform.inverse)
      sphere_to_ray = (ray2.origin - CRT::Point.new(0,0,0)).as CRT::Vector
      a = ray2.path.dot(ray2.path)
      b = 2 * ray2.path.dot(sphere_to_ray)
      c = sphere_to_ray.dot(sphere_to_ray) - 1
      disc = b**2 - 4*a*c

      if disc < 0
        [] of Intersection
      else
        [
          Intersection.new((-b-Math.sqrt(disc))/(2*a), s),
          Intersection.new((-b+Math.sqrt(disc))/(2*a), s)
        ]
      end
    end
  end
end

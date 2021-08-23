module CRT
  struct Ray
    getter origin : CRT::Point, path : CRT::Vector

    def initialize(@origin : CRT::Point, @path : CRT::Vector)
    end

    def self.hit(s : Array(Intersection)) : (Intersection | Nil)
      positives = s.select{ |i| i.t > 0 }
      positives.any? ? positives.min_by{ |i| i.t } : nil
    end

    # Applies the transform matrix to the ray
    def transform(mat : Matrix)
      Ray.new(
        CRT::Point.new(mat * origin),
        CRT::Vector.new(mat * path))
    end

    def intersections(s : CRT::Sphere)
      sphere_to_ray = (origin - CRT::Point.new(0,0,0)).as CRT::Vector
      a = path.dot(path)
      b = 2 * path.dot(sphere_to_ray)
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

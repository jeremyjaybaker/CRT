module CRT
  struct Ray
    getter origin : CRT::Point, path : CRT::Vector

    def initialize(@origin : CRT::Point, @path : CRT::Vector)
    end

    def intersection(s : CRT::Sphere)
      sphere_to_ray = (origin - s.position).as CRT::Vector
      a = path.dot(path)
      b = 2 * path.dot(sphere_to_ray)
      c = sphere_to_ray.dot(sphere_to_ray) - 1
      disc = b**2 - 4*a*c

      if disc < 0
        [] of Float64
      else
        [(-b-Math.sqrt(disc))/(2*a), (-b+Math.sqrt(disc))/(2*a)]
      end
    end
  end

  struct Sphere
    getter radius : Float64, position : CRT::Point

    def initialize(@radius : Float64, @position : CRT::Point)
    end
  end
end

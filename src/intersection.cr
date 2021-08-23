module CRT
  # Simple struct for holding a "time" t and an object by which it intersects.
  # It is used primarily by the `CRT::Ray` class.
  struct Intersection
    getter t : Float64, object : Sphere

    def initialize(@t : Float64, @object : Sphere)
    end
  end
end

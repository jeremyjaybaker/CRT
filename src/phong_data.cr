module CRT
  # Structure to encapsulate all needed data to determine lighting
  # at a specific poing using Phong Reflection
  struct PhongData
    getter light : CRT::PointLight
    # Vector from the hit point to the eye
    getter eye : CRT::Vector
    # Hit point and it's corresponding normal where light is being
    # calculated at.
    getter point : CRT::Point, normal : CRT::Vector

    def initialize(@light : CRT::PointLight, @point : CRT::Point,
                   @eye : CRT::Vector, @normal : CRT::Vector)
    end
  end
end

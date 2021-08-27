module CRT
  struct PointLight
    getter intensity : CRT::Color,
      position : CRT::Point

    def initialize(@intensity : CRT::Color, @position : CRT::Point)
    end
  end
end

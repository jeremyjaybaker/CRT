module CRT
  class Camera
    getter hsize : Int32, vsize : Int32,
      fov : Float64, transform : Matrix,
      half_width : Float64, half_height : Float64,
      pixel_size : Float64

    def initialize(@hsize, @vsize, @fov, @transform)
      @half_width, @half_height, @pixel_size = init_pixel_size
    end

    def initialize(@hsize, @vsize, @fov = CRT::PI/2)
      initialize(@hsize, @vsize, @fov, Matrix.identity(4,4))
    end

    def aspect_ratio
      @aratio ||= (@hsize / @vsize).as Float64
    end

    def view_transform(from : Point, to : Point, up : Vector)
      translation = Matrices.translation(-from.x, -from.y, -from.z)
      @transform = Matrices.view_transform(from,to,up) * translation
      self
    end

    def render(world : World)
      PixelGrid.new @vsize-1, @hsize-1 { |x,y| world.color_at(ray(x,y)) }
    end

    def offset(x_or_y : Int32)
      (x_or_y + 0.5) * @pixel_size
    end

    def world_x(object_x : Int32)
      @half_width - offset(object_x)
    end

    def world_y(object_y : Int32)
      @half_height - offset(object_y)
    end

    def origin
      Point.new(@transform.inverse * Point.origin)
    end

    def ray(x : Int32, y : Int32)
      pix = Point.new(@transform.inverse * Point.new(world_x(x), world_y(y), -1))
      path = (pix - origin).as(Vector).normal

      Ray.new(origin,path)
    end

    def ray(p : Point)
      ray(p.x.to_i, p.y.to_i)
    end

    private def init_pixel_size
      half_view = Math.tan(fov / 2)

      if aspect_ratio > 1
        half_width = half_view
        half_height = half_view / aspect_ratio
      else
        half_width = half_view * aspect_ratio
        half_height = half_view
      end

      [
        half_width,
        half_height,
        (half_width * 2) / @hsize
      ]
    end
  end
end

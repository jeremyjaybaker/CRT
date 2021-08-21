module CRT
  # Array-based structure that operates on individual pixels and can output
  # PPM file format.
  # 0,0 is treated as the bottom-left corner.
  class PixelCanvas
    getter x : Int32, y : Int32

    alias PixelGrid = Array(Array(Color))

    def initialize(@x : Int32, @y : Int32, base : Color = Color.black)
      @_pixels = PixelGrid.new
      @x.times do |i|
        @y.times do |j|
          @_pixels << Array.new(@y, base) unless @_pixels[i]?
          @_pixels[i][j] = base
        end
      end
    end

    def sample
      @_pixels.sample.sample
    end

    def draw(p : CRT::Point, c : CRT::Color)
      result = in_bounds? p
      self[p.x.to_i][p.y.to_i] = c if result
      result
    end

    def in_bounds?(p : CRT::Point)
      (0..@x).includes?(p.x) && (0..@y).includes?(p.y)
    end

    # Note: pixels can be drawn with negative coords using this method.
    # Is that a good idea? I don't think so but it's hard to prevent given
    # the second index is handed off to the Array class which is beyond
    # this class's ability to control.
    # If proper boundary detection is needed, use #draw.
    def [](key)
      @_pixels[key]
    end

    def to_a
      @_pixels.to_a.flatten
    end

    # String in the format of a PPM image type that can be written
    # directly to a new file.
    #
    # `natural_origin = true` keeps 0,0 at the top-left of the image. While it
    # makes sense to store arrays in this fashion, by default it usually feels
    # more correct for 0,0 to be at the bottom-left of the image like a cartesian
    # coordinate plane. For this reason, natural_original is set to false by
    # default to allow the origin to exist at the bottom-left.
    def to_ppm(mcv : Int32 = 255, *, natural_origin : Bool = false)
      "P3\n#{@x} #{@y}\n#{mcv}\n#{ppm_grid_string(mcv, natural_origin: natural_origin)}\n"
    end

    def write_ppm(path : String)
      File.touch(path)
      File.open(path, "w"){ |f| f << to_ppm }
    end

    # TODO: Lots of temp string creation going on here but not sure how to optimize.
    # Is optimization even that necessary for file exporting?
    def ppm_grid_string(mcv : Int32, *, natural_origin : Bool)
      largest_color_val = to_a.map{ |c| c.to_a.flatten }.flatten.max

      # Compute the colors values as they would be oriented in the color matrix.
      rows = [] of String
      @y.times do |j|
        @x.times do |i|
          rows << @_pixels[i][j].clamp.to_a.map do |a|
            (a*mcv).round.to_i.to_s
          end.join(" ")
        end
      end

      # Reversing brings 0,0 to the bottom-left instead of top-left corner.
      rows = rows.each_slice(@x).to_a.reverse.flatten unless natural_origin

      # Allow at most 5 colors on one line of the string. This is intended as an
      # easy way to guarantee the 70-char line limit imposed by many image programs
      # for the PPM file type.
      rows.each_slice(5).map do |a|
        a.join(" ")
      end.join("\n")
    end
  end
end

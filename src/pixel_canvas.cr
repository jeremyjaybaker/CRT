module CRT
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

    def [](key)
      @_pixels[key]
    end

    def to_a
      @_pixels.to_a.flatten
    end

    # String in the format of a PPM image type that can be written
    # directly to a new file.
    def to_ppm(mcv : Int32 = 255)
      "P3\n#{@x} #{@y}\n#{mcv}\n#{ppm_grid_string(mcv)}\n"
    end

    # TODO: Lots of temp string creation going on here but not sure how to optimize.
    # Is optimization even that necessary for file exporting?
    def ppm_grid_string(mcv : Int32)
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

      # Allow at most 5 colors on one line of the string. This is intended as an
      # easy way to guarantee the 70-char line limit imposed by many image programs
      # for the PPM file type.
      rows.each_slice(5).map do |a|
        a.join(" ")
      end.join("\n")
    end
  end
end

module CRTSamples
  # Array-based structure that operates on individual pixels and can output
  # PPM file format. For the purposes of writing to a PPM file, 0,0 is treated
  # as the bottom-left corner.
  #
  # Note that pixels can be read/written to the canvas via index (ie, the
  # indicies that correspond to the underlying arrays) or by coordinates that
  # are established by setting the x_start and y_start values. When x/y_start are
  # left at 0,0, the canvas can be considered to be Quadrant I of a cartesian
  # coordinate plane with the origin 0,0 at the bottom-left. Often, a different
  # layout is desired, especially a centered layout with the origin 0,0 actually
  # in the middle of the canvas so all 4 quadrants are equal in area.
  #
  # To read/write via raw indicies, use standard array notiation like
  # ```
  # canv = CRTSamples::Canvas.new(5,6)
  # canv[0][5] # row 0, col 5 -> bottom-right-most pixel
  # canv[0][6] # Gotcha: Index wrap-around returns value of canv[0][0]
  # ```
  #
  # Example using coordinates:
  # ```
  # canv = CRTSamples::Canvas.new(20,20,-10,-10)
  # canv.draw(-10,-10,CRT::Color.red) # true,
  # ```
  #
  # You can create centered canvases using the ::centered method:
  # ```
  # a = CRTSamples::Canvas.centered(20,20)
  # b = CRTSamples::Canvas.new(20,20,-10,-10)
  # a == b # true
  # ```
  #
  # Projectile sample is an example that does not use a centered grid.
  class Canvas
    getter width : Int32, height : Int32,
      x_start : Int32, y_start : Int32

    alias PixelGrid = Array(Array(CRT::Color))

    def initialize(@width : Int32, @height : Int32,
                    @x_start : Int32 = 0, @y_start : Int32 = 0,
                    base : CRT::Color = CRT::Color.black)
      @_pixels = PixelGrid.new

      ltr_traverse do |row,col|
        @_pixels << Array.new(@width, base) unless @_pixels[row]?
        @_pixels[row][col] = base
      end
    end

    # Returns a canvas where the cartesian origin 0,0 is centered in the middle
    # of the canvas.
    # NOTE: If given odd values of x or y, integer division will truncate result.
    def self.centered(width : Int32, height : Int32, c : CRT::Color = CRT::Color.black)
      new(width, height, (width/-2).to_i, (height/-2).to_i, c)
    end

    # Traverse indices from top-left to bottom-right as they are stored in the
    # PixelGrid array structure.
    def ltr_traverse(&)
      @height.times do |row|
        @width.times do |col|
          yield row,col
        end
      end
    end

    def sample
      @_pixels.sample.sample
    end

    def [](row)
      @_pixels[row]
    end

    # Draws based on coordinates, not indices. Coordinates are determined by not only
    # the width and the height, but by what values of x,y the grid starts on. This allows
    # the grid to be centered anywhere. This was implemented mainly to allow the grid's
    # cartesian origin to be in the center of the grid.
    def draw(x : Int32, y : Int32, c : CRT::Color)
      newcol = x-@x_start
      newrow = y-@y_start
      result = in_bounds?(newcol,newrow)
      self[newrow][newcol] = c if result
      result
    end

    # TODO: maybe round instead of just to to_i?
    def draw(p : CRT::Point, c : CRT::Color)
      draw(p.x.to_i, p.y.to_i, c)
    end

    # Determines whether the given x,y indicies are within the grid's coordinates.
    def in_bounds?(x : Int32, y : Int32)
      (0...@width).includes?(x) && (0...@height).includes?(y)
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
    def to_ppm(mcv : Int32 = 255)
      "P3\n#{@width} #{@height}\n#{mcv}\n#{ppm_grid_string(mcv)}\n"
    end

    def write_ppm(path : String)
      File.touch(path)
      File.open(path, "w"){ |f| f << to_ppm }
    end

    # TODO: Lots of temp string creation going on here but not sure how to optimize.
    # Is optimization even that necessary for file exporting?
    def ppm_grid_string(mcv : Int32)
      # The row ordering needs to be reveresed since iterating from 0,0 to width,height
      # is a top-left to bottom-right operation which causes the image to be flipped. This
      # is a fine way to store array data, but for actually displaying pixels, the rows
      # need to be flipped.
      rev = @_pixels.reverse

      rows = [] of String
      @height.times do |row|
        @width.times do |col|
          rows << color_to_ppm(rev[row][col], mcv)
        end
      end

      # Allow at most 5 colors on one line of the string. This is intended as an
      # easy way to guarantee the 70-char line limit imposed by many image programs
      # for the PPM file type.
      rows.each_slice(5).map do |a|
        a.join(" ")
      end.join("\n")
    end

    # Converts a color struct to a string of three ints like "20 0 255" that
    # represents the RGB values of the color relative to the Maximum Color
    # Value given. This is how pixels are represented in PPM.
    private def color_to_ppm(c : CRT::Color, mcv : Int32)
      c.clamp.to_a.map{ |a| (a*mcv).round.to_i.to_s }.join " "
    end
  end
end

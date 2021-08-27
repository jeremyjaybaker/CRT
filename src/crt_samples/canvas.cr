module CRTSamples
  # Array-based structure that operates on individual pixels and can output
  # PPM file format.
  #
  # Note that pixels can be read/written to the canvas via index (ie, the
  # indicies that correspond to the underlying arrays) or by coordinates that
  # represent x,y values. When x/y_start are left at 0,0, the canvas can be considered
  # to be Quadrant I of a cartesian coordinate plane with the origin 0,0 at the
  # bottom-left. Often, a different layout is desired, especially a centered layout with
  # the origin 0,0 actually in the middle of the canvas so all 4 quadrants are equal in area.
  #
  # To read/write via raw indicies, use standard array notiation like
  # ```
  # canv = CRTSamples::Canvas.new(5,6)
  # canv[0][5] # row 0, col 5 -> bottom-right-most pixel
  # canv[0][6] # Gotcha: Index wrap-around returns value of canv[0][0]
  # ```
  #
  # You can also traverse all indices of the grid like
  # ```canvas.index_traverse{ |i,j| ... }```
  #
  # Example using coordinates:
  # ```
  # canv = CRTSamples::Canvas.new((-10..10),(-10..10)) #=> canvas with 0,0 in the middle of the image
  # canv.draw(-10,-10,CRT::Color.red) #=> true
  # canv.draw(-50,0,CRT::Color.red)   #=> false
  # ```
  #
  # Projectile sample is an example that does not use a centered grid.
  class Canvas
    getter width : Int32, height : Int32,
      x_start : Int32, y_start : Int32

    alias PixelGrid = Array(Array(CRT::Color))

    # Initialize the canvas with a required width and height. This creates an image where
    # 0,0 is anchored at the bottom-left corner.
    def initialize(@width : Int32, @height : Int32,
                    base : CRT::Color = CRT::Color.black)
      @x_start = @y_start = 0
      @_pixels = PixelGrid.new
      init_pixels(base)
    end

    # Initialize the canvas with a domain and range that allows control of where the origin
    # is anchored on the image. Example:
    # ```
    # c1 = Canvas.new((0..9), (0..9))
    # c2 = Canvas.new(10,10)
    # c1 == c2 #=> true
    # ```
    def initialize(domain : Range(Int32,Int32), range : Range(Int32,Int32),
                   base : CRT::Color = CRT::Color.black)
      @width = domain.max - domain.min + 1
      @height = range.max - range.min + 1
      @x_start = domain.min
      @y_start = range.min
      @_pixels = PixelGrid.new
      init_pixels(base)
    end

    # Traverse raw indices of the array structure. From an output image perspective, this
    # results in a bottom-left to top-right pixel traversal.
    # Example:
    # ```
    # c = Canvas.centered(20,20)
    # col = [] of Int32
    # c.index_traverse{ |row,col| col << [col,row] }
    # col #=> [[0,0], [1,0], [2,0], ..., [19,19]]
    # ```
    def index_traverse(&)
      @height.times do |row|
        @width.times do |col|
          yield row,col
        end
      end
    end

    # Traverse the coordinate set of the canvas instead of indices. Allows for easier point/
    # vector manipulation.
    def coord_traverse(&)
      @height.times do |row|
        @width.times do |col|
          # col,row order to represent expected x,y notation
          yield col+@x_start, row+@y_start
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

    # TODO: maybe round instead of to_i?
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

    # String in the format of a PPM image type that can be written directly to a new file.
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
      index_traverse do |row,col|
        rows << color_to_ppm(rev[row][col], mcv)
      end

      # Allow at most 5 colors on one line of the string. This is intended as an
      # easy way to guarantee the 70-char line limit imposed by many image programs
      # for the PPM file type.
      rows.each_slice(5).map do |a|
        a.join(" ")
      end.join("\n")
    end

    private def init_pixels(base : CRT::Color)
      index_traverse do |row,col|
        @_pixels << Array.new(@width, base) unless @_pixels[row]?
        @_pixels[row][col] = base
      end
    end

    # Converts a color struct to a string of three ints like "20 0 255" that
    # represents the RGB values of the color relative to the Maximum Color
    # Value given. This is how pixels are represented in PPM.
    private def color_to_ppm(c : CRT::Color, mcv : Int32)
      c.clamp.to_a.map{ |a| (a*mcv).round.to_i.to_s }.join " "
    end
  end
end

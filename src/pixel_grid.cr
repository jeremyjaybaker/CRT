module CRT
  # Improved/simplified version of Canvas class used for samples.
  # TODO: document this and other new classes better
  struct PixelGrid
    getter height : Int32, width : Int32,
      pixels : Array(Array(Color))

    DEFAULT_COLOR = Color.black

    # Create a new grid with uninitialized pixels
    def initialize(@height, @width, &)
      @pixels = Array(Array(Color)).new
      @height.times do |y|
        @width.times do |x|
          @pixels << Array(Color).new(@width) unless @pixels[y]?
          @pixels[y] << yield x,y
        end
      end
    end
  end
end

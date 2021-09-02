module CRT
  class PPM
    property pixels : PixelGrid, mcv : Int32

    def initialize(@pixels, @mcv = 255)
    end

    def to_s
<<-PPM
P3
#{@pixels.width} #{@pixels.height}
#{@mcv}
#{color_string}

PPM
    end

    def to_file(path : String)
      File.touch(path)
      File.open(path, "w"){ |f| f << to_s }
    end

    # TODO: Lots of temp string creation going on here but not sure how to optimize.
    # Is optimization even that necessary for file exporting?
    private def color_string
      rows = [] of String
      @pixels.traverse do |x,y|
        rows << color_to_ppm(@pixels[y][x], mcv)
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

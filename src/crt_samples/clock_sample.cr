require "../crt"
require "./canvas"

module CRTSamples
  # Renders 12 points on a canvas that looks like a clock face
  class ClockSample
    def self.run
      canvas = CRTSamples::Canvas.new((-20..20),(-20..20))
      p = CRT::Point.new(0,15,0)

      12.times do
        canvas.draw(p.as CRT::Point, CRT::Color.rand)
        p = p.rotate_z(CRT::PI/6)
      end

      canvas.write_ppm "clock_sample.ppm"
    end
  end
end

require "../crt"
require "./canvas"

module CRTSamples
  class ClockSample
    def self.run
      canvas = CRTSamples::Canvas.centered(40,40)
      p = CRT::Point.new(0,15,0)

      12.times do
        canvas.draw(p.as CRT::Point, CRT::Color.white)
        p = p.rotate_z(CRT::PI/6)
      end

      canvas.write_ppm "clock_sample.ppm"
    end
  end
end

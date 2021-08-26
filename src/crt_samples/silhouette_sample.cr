require "../crt"
require "./canvas"

module CRTSamples
  class SilhouetteSample
    def self.run
      v = CRT::Vector.new(0,0,-1)
      s = CRT::Sphere.new(30)
      canvas = CRTSamples::Canvas.new((-50..50),(-50..50))

      canvas.coord_traverse do |x,y|
        p = CRT::Point.new(x.to_f, y.to_f, 0.0)
        r = CRT::Ray.new(p, v)

        if r.intersections(s).any?
          canvas.draw(x,y,CRT::Color.grey)
        end
      end

      canvas.write_ppm "silhouette_sample.ppm"
    end
  end
end

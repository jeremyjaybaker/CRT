require "../crt"
require "./canvas"

module CRTSamples
  class SilhouetteSample
    def self.run
      # How far back the wall is
      wall_z = -25.0
      # Distance between the observer and sphere
      dist_to_sphere = 20.0

      p = CRT::Point.new(0.0, 0.0, dist_to_sphere)
      s = CRT::Sphere.new(8)
      canvas = CRTSamples::Canvas.new((-50..50),(-50..50))

      canvas.coord_traverse do |x,y|
        v = (CRT::Point.new(x.to_f, y.to_f, wall_z) - p).as CRT::Vector
        r = CRT::Ray.new(p, v)

        if r.intersections(s).any?
          canvas.draw(x,y,CRT::Color.rand)
        end
      end

      canvas.write_ppm "silhouette_sample.ppm"
    end
  end
end

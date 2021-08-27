require "../crt"
require "./canvas"

module CRTSamples
  class SilhouetteSample
    def self.run
      # How far back the wall is. Note: isn't it weird that this changes sphere size? If
      # you think about it, the wall being further back doesn't change the observer's
      # perception of how big the sphere is IRL. The book calls this wall_z, but there's
      # gotta be a gotcha somewhere. This feels more related to FoV than distance
      # to a wall.
      wall_z = -25.0
      # Distance between the observer and sphere.
      dist_to_sphere = 20.0

      p = CRT::Point.new(0.0, 0.0, dist_to_sphere)
      s = CRT::Sphere.new.scale(10,6,10) # squished version
      # s = CRT::Sphere.new(8) # Uncomment to use unsquished
      canvas = CRTSamples::Canvas.new((-50..50),(-50..50))

      canvas.coord_traverse do |x,y|
        v = (CRT::Point.new(x.to_f, y.to_f, wall_z) - p).as CRT::Vector
        r = CRT::Ray.new(p, v)

        if r.intersections(s).any?
          canvas.draw(x,y,CRT::Color.grey)
        end
      end

      canvas.write_ppm "silhouette_sample.ppm"
    end
  end
end

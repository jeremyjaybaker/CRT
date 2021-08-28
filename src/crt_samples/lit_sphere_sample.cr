require "../crt"
require "./canvas"

module CRTSamples
  # Renders a fully-shaded sphere as if a light was cast onto it.
  class LitSphereSample
    def self.run
      wall_z = -25.0
      dist_to_sphere = 20.0

      light = CRT::PointLight.new(
        CRT::Color.new(1,1,1),
        CRT::Point.new(-10,10,-10)
      )

      s = CRT::Sphere.new(
        9,
        CRT::Material.new(CRT::Color.red)
      )

      eye_pos = CRT::Point.new(0.0, 0.0, dist_to_sphere)

      x = y = 50
      canvas = CRTSamples::Canvas.new((-x..x),(-y..y))

      canvas.coord_traverse do |x,y|
        eyev = (CRT::Point.new(x.to_f, y.to_f, wall_z) - eye_pos).as CRT::Vector
        ray = CRT::Ray.new(eye_pos, eyev.normal)

        inters = ray.intersections(s)
        if inters.any?
          hit_inter = CRT::Ray.hit(inters)
          if hit_inter
            hit_p = ray.at(hit_inter.t).as CRT::Point
            norm = hit_inter.object.normal(hit_p)
            color_to_draw = s.material.lighting(light,hit_p,-eyev,norm)
            canvas.draw(x,y,color_to_draw)
          end
        end
      end

      canvas.write_ppm "lit_sphere_sample.ppm"
    end
  end
end

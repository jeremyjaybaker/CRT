require "../crt"
require "./canvas"

module CRTSamples
  # Renders a fully-shaded sphere as if a light was cast onto it.
  class LitSphereSample
    def self.run
      puts "This will take a few seconds to generate..."

      wall_z = -25.0
      dist_from_sphere_origin = 30.0
      radius = 26.0
      # width/height of the centered canvas
      x = y = 400

      s = CRT::Sphere.new(
        radius,
        CRT::Material.new(CRT::Color.red)
      )

      light = CRT::PointLight.new(
        CRT::Color.white,
        CRT::Point.new(-50,50,40)
      )

      # Starting point of the eye
      eye_pos = CRT::Point.new(0.0, 0.0, dist_from_sphere_origin)

      canvas = CRTSamples::Canvas.new(
        ((-x/2).to_i..(x/2).to_i),
        ((-y/2).to_i..(y/2).to_i)
      )

      canvas.coord_traverse do |x,y|
        eye2pix = (CRT::Point.new(x.to_f, y.to_f, wall_z) - eye_pos).as(CRT::Vector).normal
        ray = CRT::Ray.new(eye_pos, eye2pix)
        pix2eye = -eye2pix

        inters = ray.intersections(s)
        if inters.any?
          hit = CRT::Ray.hit(inters)
          if hit
            hit_pos = ray.at(hit.t).as CRT::Point
            norm = hit.object.normal(hit_pos)
            color_to_draw = s.material.lighting(light,hit_pos,pix2eye,norm)
            canvas.draw(x,y,color_to_draw)
          end
        end
      end

      canvas.write_ppm "lit_sphere_sample.ppm"

      puts "Done"
    end
  end
end

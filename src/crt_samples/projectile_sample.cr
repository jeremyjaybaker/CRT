require "../crt"
require "./canvas"

# Sample module that includes activities from The Ray Tracer Challenge that
# aren't necessarily needed for the ray tracer itself.
module CRTSamples
  # Renders the path of a projectile being acted upon by wind and gravity.
  # You can execute the sample by running the following in bash:
  # `crystal eval 'require "./src/crt_samples/projectile_sample"; CRTSamples::ProjectileSample.run'`
  class ProjectileSample
    class Projectile
      property pos : CRT::Point, velocity : CRT::Vector

      def initialize(@pos : CRT::Point, @velocity : CRT::Vector)
      end
    end

    class Environment
      property gravity : CRT::Vector, wind : CRT::Vector

      def initialize(@gravity : CRT::Vector, @wind : CRT::Vector)
      end
    end

    class Scenario
      getter proj : Projectile, env : Environment
      def initialize(@proj : Projectile, @env : Environment)
      end

      def tick
        new_pos = @proj.pos + @proj.velocity
        new_vel = @proj.velocity + @env.gravity + @env.wind
        @proj = Projectile.new(new_pos.as(CRT::Point), new_vel.as(CRT::Vector))
      end
    end

    def self.run
      c = CRTSamples::Canvas.new(900,550)
      p = Projectile.new(CRT::Point.new(0,1,0), CRT::Vector.new(1,1,0).normal)
      e = Environment.new(CRT::Vector.new(0,-0.001,0), CRT::Vector.new(-0.0002,0,0))
      s = Scenario.new(p,e)

      # Should eventually return false when drawing a point that is out
      # of bounds of the canvas.
      while c.draw(s.proj.pos, CRT::Color.rand)
        s.tick
      end

      c.write_ppm "projectile_sample.ppm"
    end
  end
end

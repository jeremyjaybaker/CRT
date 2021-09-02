require "../crt"
require "../../spec/support/world_factory"

module CRTSamples
  class SimpleSceneSample
    def self.run
      puts "This will take a few seconds to generate..."

      world = WorldFactory.simple_scene

      camera = CRT::Camera.new(300,150,CRT::PI/3).
        view_transform(CRT::Point.new(0,1.5,-5), CRT::Point.new(0,1,0), CRT::Vector.new(0,1,0))

      CRT::PPM.new(camera.render(world)).to_file "simple_scene.ppm"

      puts "Done"
    end
  end
end

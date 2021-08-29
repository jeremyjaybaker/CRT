# Helper module for generating example worlds. This wasn't made with much planning
# or thought. It could def be expanded/redone to be more flexible or become a
# generic factory like FactoryBot.
module WorldFactory
  def self.example
    mat = CRT::Material.new(color: CRT::Color.new(0.8,1,0.6), diffuse: 0.7, specular: 0.2)
    lit = CRT::PointLight.new(CRT::Color.white, CRT::Point.new(-10,10,-10))
    CRT::World.new(objects: [
        CRT::Sphere.new(1,mat),
        CRT::Sphere.new(0.5)
      ], lights: [lit])
  end
end

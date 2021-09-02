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

  # Used in the SimpleSceneSample module
  def self.simple_scene
    floor_mat = CRT::Material.new(CRT::Color.new(1,0.9,0.9), specular: 0.0)
    floor = CRT::Sphere.new(material: floor_mat).scale(10,0.01,10)

    left_wall = CRT::Sphere.new(material: floor_mat).translate(0,0,5).
      rotate_y(CRT::PI/-4).rotate_x(CRT::PI/2).scale(10,0.01,10)

    right_wall = CRT::Sphere.new(material: floor_mat).translate(0,0,5).
      rotate_y(CRT::PI/4).rotate_x(CRT::PI/2).scale(10,0.01,10)

    mid_mat = CRT::Material.new(CRT::Color.new(0.1,1,0.5), diffuse: 0.7, specular: 0.3)
    middle_sphere = CRT::Sphere.new(material: mid_mat).translate(-0.5,1,0.5)

    right_mat = CRT::Material.new(CRT::Color.grey, diffuse: 0.7, specular: 0.3)
    right_sphere = CRT::Sphere.new(material: right_mat).translate(1.5,0.5,-0.5).
      scale(0.5,0.5,0.5)

    left_mat = CRT::Material.new(CRT::Color.new(1,0.8,0.1), diffuse: 0.7, specular: 0.3)
    left_sphere = CRT::Sphere.new(material: left_mat).translate(-1.5,0.33,-0.75).
      scale(0.33,0.33,0.33)

    # Original sample called for just light_left
    light_left = CRT::PointLight.new(CRT::Color.white, CRT::Point.new(-10,10,-10))
    light_right = CRT::PointLight.new(CRT::Color.white, CRT::Point.new(10,10,10))
    spheres = [middle_sphere, left_sphere, right_sphere, left_wall, right_wall, floor]

    CRT::World.new(objects: spheres, lights: [light_left, light_right])
  end
end

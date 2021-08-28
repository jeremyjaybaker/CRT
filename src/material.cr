module CRT
  struct Material
    getter ambient : Float64, diffuse : Float64,
      specular : Float64, shininess : Float64,
      color : CRT::Color

    def initialize(@color : CRT::Color = CRT::Color.white,
                   ambient : Float64 = 0.1,   diffuse : Float64 = 0.9,
                   specular : Float64 = 0.9,  shininess : Float64 = 200.0)
      @ambient = ambient.clamp(0.0,1.0)
      @diffuse = diffuse.clamp(0.0,1.0)
      @specular = specular.clamp(0.0,1.0)
      @shininess = shininess.clamp(10.0,200.0)
    end

    # TODO: document steps
    def lighting(l : CRT::PointLight, p : CRT::Point, eye : CRT::Vector, norm : CRT::Vector)
      effective_color = @color * l.intensity
      lightv = (l.position - p).as(CRT::Vector).normal
      amb = effective_color * @ambient
      light_dot_norm = lightv.dot(norm)

      if light_dot_norm < 0
        diff = CRT::Color.black
        spec = CRT::Color.black
      else
        diff = effective_color * @diffuse * light_dot_norm
      end

      reflectv = -lightv.reflect(norm)
      reflect_dot_eye = reflectv.dot(eye)

      if reflect_dot_eye <= 0
        spec = CRT::Color.black
      else
        factor = reflect_dot_eye ** @shininess
        spec = l.intensity * @specular * factor
      end

      amb + diff + spec
    end
  end
end

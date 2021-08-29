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

    def lighting(light : CRT::PointLight, point : CRT::Point,
                 eye : CRT::Vector, normal : CRT::Vector)
      lighting(PhongData.new(light,point,eye,normal))
    end

    def lighting(data : PhongData) : Color
      # Calculations that are shared amonst the multiple components
      effective_color = @color * data.light.intensity
      lightv = (data.light.position - data.point).as(Vector).normal

      # TODO: splitting these up is readable, but might incur too much
      # overhead by adding extra function calls?
      ambient(effective_color) +
        diffuse(data, effective_color, lightv) +
        specular(data, lightv)
    end

    def ambient(effective_color : Color) : Color
      effective_color * @ambient
    end

    def diffuse(data : PhongData, effective_color : Color, lightv : Vector) : Color
      light_dot_norm = lightv.dot(data.normal)

      if light_dot_norm < 0
        Color.black
      else
        effective_color * @diffuse * light_dot_norm
      end
    end

    def specular(data : PhongData, lightv : Vector) : Color
      reflectv = -lightv.reflect(data.normal)
      reflect_dot_eye = reflectv.dot(data.eye)

      if reflect_dot_eye <= 0
        Color.black
      else
        factor = reflect_dot_eye ** @shininess
        data.light.intensity * @specular * factor
      end
    end
  end
end

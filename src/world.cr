module CRT
  class World
    property objects : Array(Sphere),
      lights : Array(PointLight)

    # TODO: repurpose PhongData to act as Comp
    alias Comp = NamedTuple(t: Float64, object: CRT::Sphere, point: CRT::Point,
                            eye_v: CRT::Vector, normal_v: CRT::Vector, is_inside: Bool)

    def initialize(@objects = Array(Sphere).new, @lights = Array(PointLight).new)
    end

    def intersections(ray : Ray)
      objects.flat_map{ |obj| ray.intersections(obj) }.sort_by(&.t)
    end

    def color_at(ray : Ray)
      positive_inters = comps(ray).select{ |c| c[:t] > 0 }
      if positive_inters.any?
        hit = positive_inters.min_by{ |c| c[:t] }
        @lights.map do |li|
          hit[:object].material.lighting(li, hit[:point], hit[:eye_v], hit[:normal_v])
        end.sum
      else
        Color.black
      end
    end

    # TODO: this isn't well-named and probably shouldn't belong in the World class
    def comps(ray : Ray) : Array(Comp)
      intersections(ray).map do |inter|
        point = ray.at(inter.t).as Point
        normalv = inter.object.normal(point)
        is_inside = normalv.dot(-ray.path) < 0
        {
          t:          inter.t,
          object:     inter.object,
          point:      point,
          eye_v:      -ray.path,
          normal_v:   is_inside ? -normalv : normalv,
          is_inside:  is_inside
        }
      end
    end
  end
end

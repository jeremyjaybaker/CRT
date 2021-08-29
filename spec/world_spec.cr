require "./spec_helper"

describe CRT::World do
  it "can have lights" do
    w = CRT::World.new(lights: [CRT::PointLight.new(CRT::Color.white, CRT::Point.origin)])
    w.lights.size.should eq 1
  end

  it "can have objects" do
    w = CRT::World.new(objects: [CRT::Sphere.new, CRT::Sphere.new])
    w.objects.size.should eq 2
  end

  it "has a example world" do
    WorldFactory.example.should be_a CRT::World
  end

  it "can determine obj intersections" do
    w = WorldFactory.example
    r = CRT::Ray.new(CRT::Point.new(0,0,-5), CRT::Vector.new(0,0,1))
    inters = w.intersections(r)
    inters.size.should eq 4
    inters.map(&.t).should eq [4.0,4.5,5.5,6.0]
  end

  it "can pre-compute interactions for a given ray" do
    w = WorldFactory.example
    r = CRT::Ray.new(CRT::Point.new(0,0,-5), CRT::Vector.new(0,0,1))
    ret = w.comps(r).find{ |a| a[:t] == 4.0 }
    if ret
      ret[:point].should eq CRT::Point.new(0,0,-1)
      ret[:eye_v].should eq CRT::Vector.new(0,0,-1)
      ret[:normal_v].should eq CRT::Vector.new(0,0,-1)
    else
      true.should be_false
    end
  end

  describe "color at a ray" do
    context "from an outside collision" do
      it "returns a color" do
        w = WorldFactory.example
        r = CRT::Ray.new(CRT::Point.new(0,0,-5), CRT::Vector.new(0,0,1))
        w.color_at(r).should eq CRT::Color.new(0.38066,0.47583,0.2855)
      end
    end

    context "from an inside collision" do
      it "returns a color" do
        w = WorldFactory.example
        w.lights = [CRT::PointLight.new(CRT::Color.white, CRT::Point.new(0,0.25,0))]
        r = CRT::Ray.new(CRT::Point.origin, CRT::Vector.new(0,0,1))
        w.color_at(r).should eq CRT::Color.new(0.90498,0.90498,0.90498)
      end
    end
  end
end

require "./spec_helper"

describe CRT::Material do
  pos = CRT::Point.new(0,0,0)
  mat = CRT::Material.new

  describe "lighting" do
    normalv = CRT::Vector.new(0,0,-1)
    light = CRT::PointLight.new(CRT::Color.new(1,1,1), CRT::Point.new(0,0,-10))

    context "lighting with eye between source and surface" do
      it "returns an intense color" do
        eyev = CRT::Vector.new(0,0,-1)
        mat.lighting(light, pos, eyev, normalv).should eq CRT::Color.new(1.9,1.9,1.9)
      end
    end

    context "eye offset 45 deg between surface and source" do
      it "returns less intense light" do
        dim = Math.sqrt(2)/2
        eyev = CRT::Vector.new(0,dim,-dim)
        mat.lighting(light, pos, eyev, normalv).should eq CRT::Color.new(1.0,1.0,1.0)
      end
    end

    context "eye offset downwards between surface and source" do
      it "returns less intense light" do
        dim = Math.sqrt(2)/2
        eyev = CRT::Vector.new(0,0,-1)
        light = CRT::PointLight.new(CRT::Color.new(1,1,1), CRT::Point.new(0,10,-10))
        mat.lighting(light, pos, eyev, normalv).should eq CRT::Color.new(0.7364,0.7364,0.7364)
      end
    end

    context "eye is in the path of the reflection vector (max spec intensity)" do
      it "returns intense specular light" do
        dim = Math.sqrt(2)/2
        eyev = CRT::Vector.new(0,-dim,-dim)
        light = CRT::PointLight.new(CRT::Color.new(1,1,1), CRT::Point.new(0,10,-10))
        mat.lighting(light, pos, eyev, normalv).should eq CRT::Color.new(1.6364,1.6364,1.6364)
      end
    end

    context "the light source is behind the object" do
      it "returns darkness" do
        eyev = CRT::Vector.new(0,0,-1)
        light = CRT::PointLight.new(CRT::Color.new(1,1,1), CRT::Point.new(0,0,10))
        mat.lighting(light, pos, eyev, normalv).should eq CRT::Color.new(0.1,0.1,0.1)
      end
    end
  end
end

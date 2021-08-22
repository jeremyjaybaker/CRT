require "./spec_helper"

describe CRT::Ray do
  describe "determining intersection points of a sphere" do
    s = CRT::Sphere.new(1, CRT::Point.new(0,0,0))

    context "with an origin 'behind' sphere" do
      context "with an intersection through the center" do
        it "returns the two intersection points" do
          ray = CRT::Ray.new(CRT::Point.new(0,0,-5), CRT::Vector.new(0,0,1))
          ray.intersection(s).should eq [4.0,6.0]
        end
      end

      context "with a tangential intersection" do
        it "returns the single intersection point twice" do
          ray = CRT::Ray.new(CRT::Point.new(0,1,-5), CRT::Vector.new(0,0,1))
          ray.intersection(s).should eq [5.0,5.0]
        end
      end
    end

    context "with the origin inside of the sphere" do
      it "returns the two intersection points" do
        ray = CRT::Ray.new(CRT::Point.new(0,0,0), CRT::Vector.new(0,0,1))
        ray.intersection(s).should eq [-1.0,1.0]
      end
    end

    context "with the origin 'in front of' the sphere" do
      it "returns the two intersection points" do
        ray = CRT::Ray.new(CRT::Point.new(0,0,5), CRT::Vector.new(0,0,1))
        ray.intersection(s).should eq [-6.0,-4.0]
      end
    end

    context "with no intersection" do
      it "returns a blank array" do
        ray = CRT::Ray.new(CRT::Point.new(0,2,-5), CRT::Vector.new(0,0,1))
        ray.intersection(s).should eq([] of Float64)
      end
    end
  end
end

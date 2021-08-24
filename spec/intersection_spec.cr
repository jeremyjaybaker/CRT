require "./spec_helper"

describe CRT::Intersection do
  describe "equivalence" do
    it "must have the same t and object" do
      inter = CRT::Intersection.new(4, CRT::Sphere.new)
      inter.should eq CRT::Intersection.new(4, CRT::Sphere.new)
    end

    it "cannot have a different t value" do
      inter = CRT::Intersection.new(4, CRT::Sphere.new)
      inter.should_not eq CRT::Intersection.new(2, CRT::Sphere.new)
    end

    it "cannot have a different object" do
      inter = CRT::Intersection.new(4, CRT::Sphere.new)
      inter.should_not eq CRT::Intersection.new(4, CRT::Sphere.new(4))
    end
  end
end

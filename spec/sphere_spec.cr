require "./spec_helper"

describe CRT::Sphere do
  it "can be given a radius" do
    s = CRT::Sphere.new(5)
    s.transform.should eq CRT::Matrices.scale(5,5,5)
  end
end

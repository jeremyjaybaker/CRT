require "./spec_helper"

describe CRT::Sphere do
  it "has a transformation" do
    CRT::Sphere.new(5, CRT::Point.new(0,0,0)).transform.should eq CRT::Matrix.identity(4,4)
  end
end

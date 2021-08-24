require "./spec_helper"

describe CRT::Sphere do
  it "has a transformation" do
    CRT::Sphere.new(5).transform.should eq CRT::Matrix.identity(4,4)
  end

  it "can be given a transformation" do
    s = CRT::Sphere.new
    trans = CRT::Matrix.new(4,4, 1,2,3,4, 5,6,7,8, 1,2,3,4, 5,6,7,8)
    s.transform = trans
    s.transform.should eq trans
  end
end

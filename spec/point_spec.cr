require "./spec_helper"

describe CRT::Point do
  p1 = CRT::Point.new(-3,4,5)

  it "can translates coords" do
    p1.translate(5,-3,2).should eq CRT::Point.new(2,1,7)
  end

  it "can scale coords" do
    p1.scale(2,3,4).should eq CRT::Point.new(-6,12,20)
  end

  describe "rotation" do
    it "can rotate around the x axis" do
      p = CRT::Point.new(0,1,0).rotate_x(CRT::PI/2)
      p.should eq CRT::Point.new(0,0,1)
    end

    it "can rotate around the y axis" do
      p = CRT::Point.new(0,0,1).rotate_y(CRT::PI/2)
      p.should eq CRT::Point.new(1,0,0)
    end

    it "can rotate around the z axis" do
      p = CRT::Point.new(0,-1,0).rotate_z(CRT::PI/2)
      p.should eq CRT::Point.new(1,0,0)
    end
  end
end

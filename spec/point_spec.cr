require "./spec_helper"

describe CRT::Point do
  p1 = CRT::Point.new(-3,4,5)

  it "can translates coords" do
    p1.translate(5,-3,2).should eq CRT::Point.new(2,1,7)
  end

  it "can scale coords" do
    p1.scale(2,3,4).should eq CRT::Point.new(-6,12,20)
  end
end

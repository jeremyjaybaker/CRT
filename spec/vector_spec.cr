require "./spec_helper"

# These tests are not comprehensive as the majority of
# functionality is already tested in space_spec.cr
describe CRT::Vector do
  v1 = CRT::Vector.new(1,2,3)
  v2 = CRT::Vector.new(4,5,6)

  it "can be negated" do
    (-v1).should eq CRT::Vector.new(-1,-2,-3)
  end

  it "has a #w of 0" do
    v1.w.should eq 0
  end

  it "can be multiplied by a scalar" do
    (v1 * 2).should eq CRT::Vector.new(2,4,6)
  end

  it "can be divided by a scalar" do
    (v1 / 2).should eq CRT::Vector.new(0.5,1,1.5)
  end

  it "can be added to another vector" do
    (v1 + v2).should eq CRT::Vector.new(5,7,9)
  end

  it "can be subtracted from another vector" do
    (v1 - v2).should eq CRT::Vector.new(-3,-3,-3)
  end
end

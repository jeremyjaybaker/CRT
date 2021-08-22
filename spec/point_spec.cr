require "./spec_helper"

describe CRT::Point do
  p1 = CRT::Point.new(-3,4,5)
  p2 = CRT::Point.new(1,2,3)
  p3 = CRT::Point.new(4,5,6)

  it "can be negated" do
    (-p1).should eq CRT::Point.new(3,-4,-5)
  end

  it "has a #w of 1" do
    p1.w.should eq 1
  end

  it "cannot be initialized with a bad matrix" do
    begin
      CRT::Point.new(CRT::Matrix.new(2,2, 1,2,3,4))
    rescue CRT::BaseVector::InvalidMatrix
      true.should be_true
      next
    end
    false.should be_false
  end

  it "cannot be multiplied by a scalar" do
    begin
      p2 * 2
    rescue CRT::BaseVector::InvalidMatrix
      true.should be_true
      next
    end
    false.should be_true
  end

  it "cannot be divided by a scalar" do
    begin
      p2 / 2
    rescue CRT::BaseVector::InvalidMatrix
      true.should be_true
      next
    end
    false.should be_true
  end

  it "can be added to a vector" do
    vec = CRT::Vector.new(1,1,1)
    (p2 + vec).should eq CRT::Point.new(2,3,4)
  end

  it "cannot be added to another point" do
    begin
      p2 + p3
    rescue e : CRT::BaseVector::InvalidMatrix
      e.to_s.should match /Cannot initialize/
      next
    end
    false.should be_true
  end

  it "can be subtracted from a vector" do
    vec = CRT::Vector.new(1,1,1)
    (p2 - vec).should eq CRT::Point.new(0,1,2)
  end

  it "can be subtracted from another point" do
    (p2 - p3).should eq CRT::Vector.new(-3,-3,-3)
    (p2 - p3).class.should eq CRT::Vector
  end

  it "translates coords" do
    p1.translate(5,-3,2).should eq CRT::Point.new(2,1,7)
  end

  it "can scale coords" do
    p = CRT::Point.new(-4,6,8)
    p.scale(2,3,4).should eq CRT::Point.new(-8,18,32)
  end

  it "can correctly chain multiple transformation calls" do
    p = CRT::Point.new(1,0,1)
    expected = CRT::Point.new(15,0,7)
    p.rotate_x(CRT::PI/2).scale(5,5,5).translate(10,5,7).should eq expected
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

  describe "shearing" do
    p = CRT::Point.new(2,3,4)

    it "can shear x relative to y" do
      p.shear(1).should eq CRT::Point.new(5,3,4)
    end

    it "can shear x relative to z" do
      p.shear(0,1).should eq CRT::Point.new(6,3,4)
    end

    it "can shear y relative to x" do
      p.shear(0,0,1).should eq CRT::Point.new(2,5,4)
    end

    it "can shear y relative to z" do
      p.shear(0,0,0,1).should eq CRT::Point.new(2,7,4)
    end

    it "can shear z relative to x" do
      p.shear(0,0,0,0,1).should eq CRT::Point.new(2,3,6)
    end

    it "can shear z relative to y" do
      p.shear(0,0,0,0,0,1).should eq CRT::Point.new(2,3,7)
    end
  end
end

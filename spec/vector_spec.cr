require "./spec_helper"

describe CRT::Vector do
  v1 = CRT::Vector.new(1,2,3)
  v2 = CRT::Vector.new(4,5,6)
  v3 = CRT::Vector.new(2,3,4)

  it "can be negated" do
    (-v1).should eq CRT::Vector.new(-1,-2,-3)
  end

  it "can coerce an invalid matrix into a vector" do
    bad_mat = CRT::Matrix.new(4,1, 1,2,3,99)
    CRT::Vector.coerce(bad_mat).should be_a CRT::Vector
  end

  it "can calculate a reflection vector" do
    v_1 = CRT::Vector.new(1,-1,0)
    v_2 = CRT::Vector.new(0,-1,0)
    dim = Math.sqrt(2)/2
    v_1.reflect(CRT::Vector.new(0,1,0)).should eq CRT::Vector.new(1,1,0)
    v_2.reflect(CRT::Vector.new(dim,dim,0)).should eq CRT::Vector.new(1,0,0)
  end

  it "has a #w of 0" do
    v1.w.should eq 0
  end

  it "has a magnitude" do
    v1.magnitude.should be_close 3.7416, 0.001
  end

  it "has a normal vector" do
    v1.normal.should eq CRT::Vector.new(0.26726,0.53452,0.80178)
    v1.normal.magnitude.should eq 1.0
  end

  it "can compute a dot product with another vector" do
    v1.dot(v3).should eq 20.0
  end

  it "can compute a cross product with another vector" do
    v1.cross(v3).should eq CRT::Vector.new(-1,2,-1)
    v3.cross(v1).should eq CRT::Vector.new(1,-2,1)
  end

  it "cannot be initialized with a bad matrix" do
    begin
      CRT::Vector.new(CRT::Matrix.new(4,1, 1,2,3,99))
    rescue CRT::BaseVector::InvalidMatrix
      true.should be_true
      next
    end
    false.should be_false
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

  it "translates coords to a copy of itself" do
    v1.translate(1,2,3).should eq CRT::Vector.new(1,2,3)
  end

  it "can scale coords" do
    v1.scale(2,3,4).should eq CRT::Vector.new(2,6,12)
  end

  describe "rotation" do
    it "can rotate around the x axis" do
      p = CRT::Vector.new(0,1,0).rotate_x(CRT::PI/2)
      p.should eq CRT::Vector.new(0,0,1)
    end

    it "can rotate around the y axis" do
      p = CRT::Vector.new(0,0,1).rotate_y(CRT::PI/2)
      p.should eq CRT::Vector.new(1,0,0)
    end

    it "can rotate around the z axis" do
      p = CRT::Vector.new(0,-1,0).rotate_z(CRT::PI/2)
      p.should eq CRT::Vector.new(1,0,0)
    end
  end

  describe "shearing" do
    p = CRT::Vector.new(2,3,4)

    it "can shear x relative to y" do
      p.shear(1).should eq CRT::Vector.new(5,3,4)
    end

    it "can shear x relative to z" do
      p.shear(0,1).should eq CRT::Vector.new(6,3,4)
    end

    it "can shear y relative to x" do
      p.shear(0,0,1).should eq CRT::Vector.new(2,5,4)
    end

    it "can shear y relative to z" do
      p.shear(0,0,0,1).should eq CRT::Vector.new(2,7,4)
    end

    it "can shear z relative to x" do
      p.shear(0,0,0,0,1).should eq CRT::Vector.new(2,3,6)
    end

    it "can shear z relative to y" do
      p.shear(0,0,0,0,0,1).should eq CRT::Vector.new(2,3,7)
    end
  end
end

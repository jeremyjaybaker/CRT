require "./spec_helper"

describe CRT::Sphere do
  it "can be given a radius" do
    s = CRT::Sphere.new(5)
    s.transform.should eq CRT::Matrices.scale(5,5,5)
  end

  it "persists its material after a transform" do
    mat = CRT::Material.new(CRT::Color.red)
    s = CRT::Sphere.new(1, mat)
    s.shear(2,2).material.should eq s.material
  end

  describe "determining a normal vector" do
    it "returns the normal without transforms" do
      s = CRT::Sphere.new
      dim = Math.sqrt(3)/3
      s.normal(1,0,0).should eq CRT::Vector.new(1,0,0)
      s.normal(0,1,0).should eq CRT::Vector.new(0,1,0)
      s.normal(0,0,1).should eq CRT::Vector.new(0,0,1)
      s.normal(dim,dim,dim).should eq CRT::Vector.new(dim,dim,dim)
      s.normal(dim,dim,dim).should eq s.normal(dim,dim,dim).normal
    end

    it "can return the normal with transforms" do
      s = CRT::Sphere.new.scale(1,0.5,1).rotate_z(CRT::PI/5)
      dim = Math.sqrt(2)/2
      s.normal(CRT::Point.new(0,dim,-dim)).should eq CRT::Vector.new(0,0.97014,-0.24254)
    end
  end
end

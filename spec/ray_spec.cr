require "./spec_helper"

describe CRT::Ray do
  s = CRT::Sphere.new

  describe "determining intersection pointers of a sphere" do
    context "with an origin 'behind' sphere" do
      context "with an intersection through the center" do
        it "returns the two intersection pointers" do
          ray = CRT::Ray.new(CRT::Point.new(0,0,-5), CRT::Vector.new(0,0,1))
          inters = [CRT::Intersection.new(4.0,s),CRT::Intersection.new(6.0,s)]
          ray.intersections(s).should eq inters
        end

        it "returns correct coords even with a scaled sphere" do
          ray = CRT::Ray.new(CRT::Point.new(0,0,-5), CRT::Vector.new(0,0,1))
          sc = CRT::Sphere.new(2)
          inters = [CRT::Intersection.new(3.0,sc),CRT::Intersection.new(7.0,sc)]
          ray.intersections(sc).should eq inters
        end
      end

      context "with a tangential intersection" do
        it "returns the single intersection point twice" do
          ray = CRT::Ray.new(CRT::Point.new(0,1,-5), CRT::Vector.new(0,0,1))
          inters = [CRT::Intersection.new(5.0,s),CRT::Intersection.new(5.0,s)]
          ray.intersections(s).should eq inters
        end
      end
    end

    context "with the origin inside of the sphere" do
      it "returns the two intersection pointers" do
        ray = CRT::Ray.new(CRT::Point.new(0,0,0), CRT::Vector.new(0,0,1))
        inters = [CRT::Intersection.new(-1.0,s),CRT::Intersection.new(1.0,s)]
        ray.intersections(s).should eq inters
      end
    end

    context "with the origin 'in front of' the sphere" do
      it "returns the two intersection pointers" do
        ray = CRT::Ray.new(CRT::Point.new(0,0,5), CRT::Vector.new(0,0,1))
        inters = [CRT::Intersection.new(-6.0,s),CRT::Intersection.new(-4.0,s)]
        ray.intersections(s).should eq inters
      end
    end

    context "with no intersection" do
      it "returns a blank array" do
        ray = CRT::Ray.new(CRT::Point.new(0,2,-5), CRT::Vector.new(0,0,1))
        ray.intersections(s).should eq([] of Float64)
      end
    end
  end

  describe "determining a ray hit from a set of Interactions" do
    context "with a head-on ray hit" do
      it "returns object with the lowest non-negative t" do
        ray = CRT::Ray.new(CRT::Point.new(0,0,-5), CRT::Vector.new(0,0,1))
        expected = CRT::Intersection.new(4.0,s)
        inters = [expected,CRT::Intersection.new(6.0,s)]
        CRT::Ray.hit(inters).should eq expected
      end
    end

    context "with a hit where some interactions have neg t" do
      it "returns object with the lowest non-negative t" do
        ray = CRT::Ray.new(CRT::Point.new(0,0,0), CRT::Vector.new(0,0,1))
        expected = CRT::Intersection.new(1.0,s)
        inters = [CRT::Intersection.new(-1.0,s),expected]
        CRT::Ray.hit(inters).should eq expected
      end
    end

    context "with a hit where all interactions have neg t" do
      it "returns object with the lowest non-negative t" do
        ray = CRT::Ray.new(CRT::Point.new(0,0,5), CRT::Vector.new(0,0,1))
        inters = [CRT::Intersection.new(-4.0,s),CRT::Intersection.new(-6.0,s)]
        CRT::Ray.hit(inters).should eq nil
      end
    end

    context "with a miss" do
      it "returns blank" do
        ray = CRT::Ray.new(CRT::Point.new(0,2,-5), CRT::Vector.new(0,0,1))
        inters = ray.intersections(s)
        CRT::Ray.hit(inters).should eq nil
      end
    end
  end

  describe "applying a transform to the ray" do
    r = CRT::Ray.new(CRT::Point.new(1,2,3), CRT::Vector.new(0,1,0))

    it "can translate the ray" do
      mat = CRT::Matrices.translation(3,4,5)
      expected = CRT::Ray.new(CRT::Point.new(4,6,8), CRT::Vector.new(0,1,0))
      r.transform(mat).should eq expected
    end

    it "can scale the ray" do
      mat = CRT::Matrices.scale(2,3,4)
      expected = CRT::Ray.new(CRT::Point.new(2,6,12), CRT::Vector.new(0,3,0))
      r.transform(mat).should eq expected
    end
  end

  describe "returning the point along path at t" do
    it "can return the point" do
      r1 = CRT::Ray.new(CRT::Point.new(0,0,0), CRT::Vector.new(0,1,0))
      r1.at(0.0).should eq CRT::Point.new(0,0,0)
      r1.at(0.5).should eq CRT::Point.new(0,0.5,0)
      r1.at(5.0).should eq CRT::Point.new(0,5,0)
    end
  end
end

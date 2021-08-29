require "./spec_helper"

describe CRT::Camera do
  describe "pixel size" do
    context "with a horizontal canvas" do
      it "has a pixel size" do
        cam = CRT::Camera.new(200,125)
        cam.pixel_size.should be_close 0.01, 0.0001
      end
    end

    context "with a vertical canvas" do
      it "has a pixel size" do
        cam = CRT::Camera.new(125,200)
        cam.pixel_size.should be_close 0.01, 0.0001
      end
    end
  end

  describe "ray at a pixel" do
    context "with an untransformed camera" do
      cam = CRT::Camera.new(201,101)

      it "returns a ray" do
        ray1 = cam.ray(100,50)
        ray1.origin.should eq CRT::Point.origin
        ray1.path.should eq CRT::Vector.new(0,0,-1)
        ray2 = cam.ray(0,0)
        ray2.origin.should eq CRT::Point.origin
        ray2.path.should eq CRT::Vector.new(0.66519,0.33259,-0.66851)
      end
    end

    context "with a transformed camera" do
      tmatrix = CRT::Matrices.rotation_y(CRT::PI/4) *
        CRT::Matrices.translation(0,-2,5)
      cam = CRT::Camera.new(201,101,CRT::PI/2,tmatrix)

      it "returns a ray" do
        ray = cam.ray(100,50)
        dim = Math.sqrt(2)/2
        ray.origin.should eq CRT::Point.new(0,2,-5)
        ray.path.should eq CRT::Vector.new(dim,0,-dim)
      end
    end
  end

  it "can set/return a view transformation" do
    cam = CRT::Camera.new(10,10)
    up = CRT::Vector.new(0,1,0)

    cam.view_transform(CRT::Point.origin, CRT::Point.new(0,0,1), up)
    cam.transform.should eq CRT::Matrices.scale(-1,1,-1)

    cam.view_transform(CRT::Point.new(0,0,8), CRT::Point.origin, up)
    cam.transform.should eq CRT::Matrices.translation(0,0,-8)

    cam.view_transform(
      CRT::Point.new(1,3,2), CRT::Point.new(4,-2,8), CRT::Vector.new(1,1,0))
    expected = CRT::Matrix.new(4,4, -0.50709, 0.50709, 0.67612,  -2.36643,
                                    0.76772,  0.60609, 0.12122,  -2.82843,
                                    -0.35857, 0.59761, -0.71714, 0.0,
                                    0.0,      0.0,     0.0,      1.0)
    cam.transform.should eq expected
  end

  it "can render a world" do
    w = WorldFactory.example
    from = CRT::Point.new(0,0,-5)
    to = CRT::Point.origin
    up = CRT::Vector.new(0,1,0)
    cam = CRT::Camera.new(11,11).view_transform(from,to,up)
    grid = cam.render(w)
    grid.pixels[5][5].should eq CRT::Color.new(0.38066,0.47583,0.2855)
  end
end

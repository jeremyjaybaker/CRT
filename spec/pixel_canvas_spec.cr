require "./spec_helper"

describe CRT::PixelCanvas do
  it "can be initialized with all black" do
    CRT::PixelCanvas.new(10,20).sample.should eq CRT::Color.black
  end

  it "can write and read colors to/from a pixel" do
    pc = CRT::PixelCanvas.new(10,20)
    pc[2][2] = CRT::Color.white
    pc[2][2].should eq CRT::Color.white
  end

  describe "the PPM format" do
    it "can return a string in PPM format" do
      pc = CRT::PixelCanvas.new(5,3)
      pc[0][0] = CRT::Color.new(1.5,0,0)
      pc[2][1] = CRT::Color.new(0,0.5,0)
      pc[4][2] = CRT::Color.new(-0.5,0,1)
      pixel_lines = pc.to_ppm.split("\n")[3..5].join("\n")
      pixel_lines.should eq <<-STR
255 0 0 0 0 0 0 0 0 0 0 0 0 0 0
0 0 0 0 0 0 0 128 0 0 0 0 0 0 0
0 0 0 0 0 0 0 0 0 0 0 0 0 0 255
STR
    end

    it "wont write lines longer than 70 chars" do
      pc = CRT::PixelCanvas.new(10,2,CRT::Color.new(1,0.8,0.6))
      rand_line = pc.to_ppm.split("\n").sample
      rand_line.size.should be <= 70
    end

    it "ends in a newline" do
      CRT::PixelCanvas.new(5,3).to_ppm[-1].should eq '\n'
    end
  end
end

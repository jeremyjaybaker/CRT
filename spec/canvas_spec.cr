require "./spec_helper"
require "../src/crt_samples/canvas"

describe CRTSamples::Canvas do
  it "can be initialized with all black" do
    CRTSamples::Canvas.new(10,20).sample.should eq CRT::Color.black
  end

  it "can create a origin-centered grid" do
    pc = CRTSamples::Canvas.centered(50,50)
    pc.x_start.should eq -25
    pc.y_start.should eq -25
  end

  describe "writing/reading colors by index" do
    it "can use indices" do
      pc = CRTSamples::Canvas.new(10,20)
      pc[2][2] = CRT::Color.white
      pc[2][2].should eq CRT::Color.white
    end

    context "with #draw" do
      it "draws the pixel when in bounds" do
        pc = CRTSamples::Canvas.new(10,20)
        pc.draw(CRT::Point.new(2,2,0), CRT::Color.white).should be_true
        pc[2][2].should eq CRT::Color.white
      end

      it "returns false if out of bounds" do
        pc = CRTSamples::Canvas.new(10,20)
        pc.draw(CRT::Point.new(99,99,0), CRT::Color.white).should be_false
        pc.draw(CRT::Point.new(-1,99,0), CRT::Color.white).should be_false
      end
    end
  end

  describe "writing/reading colors by coordinate" do
    it "can write pixels" do
      pc = CRTSamples::Canvas.centered(20,20)
      pc.draw(0,0,CRT::Color.red).should be_true
      pc[10][10].should eq CRT::Color.red

      pc.draw(9,9,CRT::Color.red).should be_true
      pc[19][19].should eq CRT::Color.red

      pc.draw(-10,-10,CRT::Color.red).should be_true
      pc[0][0].should eq CRT::Color.red

      pc.draw(10,10,CRT::Color.red).should be_false
    end
  end

  describe "the PPM format" do
    it "returns a string in PPM format with origin at bottom-left" do
      pc = CRTSamples::Canvas.new(5,3)
      pc[0][0] = CRT::Color.new(1.5,0,0)
      pc[1][2] = CRT::Color.new(0,0.5,0)
      pc[2][4] = CRT::Color.new(-0.5,0,1)
      pixel_lines = pc.to_ppm.split("\n")[3..5].join("\n")
      pixel_lines.should eq <<-STR
0 0 0 0 0 0 0 0 0 0 0 0 0 0 255
0 0 0 0 0 0 0 128 0 0 0 0 0 0 0
255 0 0 0 0 0 0 0 0 0 0 0 0 0 0
STR
    end

    it "wont write lines longer than 70 chars" do
      pc = CRTSamples::Canvas.new(10,2,0,0,CRT::Color.new(1,0.8,0.6))
      rand_line = pc.to_ppm.split("\n").sample
      rand_line.size.should be <= 70
    end

    it "ends in a newline" do
      CRTSamples::Canvas.new(5,3).to_ppm[-1].should eq '\n'
    end
  end
end

require "./spec_helper"

describe CRT::Color do
  c1 = CRT::Color.new(1,2,3)
  c2 = CRT::Color.new(4,5,6)

  describe "initialization" do
    it "can be initialized from individual values" do
      CRT::Color.new(0.5,0.2,0.1).should be_a CRT::Color
    end

    it "can be initialized with a valid matrix" do
      CRT::Color.new(CRT::Matrix.new(3,1, 1,2,3)).should be_a CRT::Color
    end

    it "raises an exception if initialized with an invalid matrix" do
      begin
        CRT::Color.new(CRT::Matrix.new(2,2, 1,2,3,4))
      rescue e : CRT::Color::InvalidMatrix
        e.to_s.should match /Cannot create color/
        next
      end
      false.should be_true
    end
  end

  it "can be added to another color" do
    (c1 + c2).should eq CRT::Color.new(5,7,9)
  end

  it "can subtracted from another color" do
    (c2 - c1).should eq CRT::Color.new(3,3,3)
  end

  it "can be multiplied by a scalar" do
    (c1 * 5).should eq CRT::Color.new(5,10,15)
  end

  it "can be multiplied by a color" do
    (c1 * c2).should eq CRT::Color.new(4,10,18)
  end
end

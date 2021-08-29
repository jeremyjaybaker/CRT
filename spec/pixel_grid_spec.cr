require "./spec_helper"

describe CRT::PixelGrid do
  it "has easy methods for writing colors to it" do
    grid = CRT::PixelGrid.new 5,5 { |x,y| CRT::Color.red }
    grid.pixels.flatten.uniq.should eq [CRT::Color.red]
  end
end

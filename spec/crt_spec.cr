require "./spec_helper"

describe CRT do
  describe "comparing floating points" do
    context "with diff less than epsilon" do
      it "is equal" do
        CRT.equal?(1.0000001, 1.0).should be_true
      end
    end

    context "with diff equal to epsilon" do
      it "is not equal" do
        CRT.equal?(1.00001, 1.0).should be_false
      end
    end

    context "with diff greater than epsilon" do
      it "is not equal" do
        CRT.equal?(1.1, 1.0).should be_false
      end
    end
  end
end

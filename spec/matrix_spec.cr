require "./spec_helper"

describe CRT::Matrix do
  m1 = CRT::Matrix.new(2,2, 1,2,3,4)
  m2 = CRT::Matrix.new(2,2, 5,6,7,8)
  m3 = CRT::Matrix.new(1,1, 5)
  m4 = CRT::Matrix.new(2,4, 1,2,3,4,5,6,7,8)

  it "has a size" do
    m1.size.should eq [2,2]
  end

  it "can create an identity matrix of arbitrary size" do
    CRT::Matrix.identity(3,3).should eq CRT::Matrix.new(3,3, 1,0,0, 0,1,0, 0,0,1)
  end

  it "can be converted to an array" do
    m1.to_a.should eq [1,2,3,4]
  end

  it "can compute its transpose" do
    m4.transpose.should eq CRT::Matrix.new(4,2, 1,5,2,6,3,7,4,8)
  end

  it "cannot access negative-index elements" do
    begin
      m1[0][-1]
    rescue IndexError
      true.should be_true
      next
    end
    false.should be_false
  end

  describe "initialization" do
    context "with values equal to element count" do
      it "can be initialized" do
        m1[1][1].should eq 4
      end
    end

    context "with values less than element count" do
      it "can be initialized and fills remaining elements with zero" do
        CRT::Matrix.new(2,2, 1,2,3)[1][1].should eq 0
      end
    end

    context "with values greater than element count" do
      it "raises an exception" do
        begin
          CRT::Matrix.new(2,2, 1,2,3,4,5)[1][1]
        rescue CRT::MatrixErrors::MismatchedElementCount
          true.should be_true
          next
        end
        false.should be_true
      end
    end
  end

  describe "equality" do
    context "with matrices of equal dimensions" do
      context "with exact values" do
        it "is equal" do
          CRT::Matrix.new(2,2, 1,2,3,4).should eq CRT::Matrix.new(2,2, 1,2,3,4)
        end
      end

      context "with significantly similar values" do
        it "is equal" do
          m = CRT::Matrix.new(2,2, 1.0000001,2,3,4)
          m.should eq CRT::Matrix.new(2,2, 1,2,3,4)
        end
      end

      context "with significantly different values" do
        it "is not equal" do
          CRT::Matrix.new(2,2, 1.1,2,3,4).should_not eq CRT::Matrix.new(2,2, 1,2,3,4)
        end
      end
    end

    context "with matrices of different dimensions" do
      it "is not equal" do
        CRT::Matrix.new(1,4, 1,2,3,4).should_not eq CRT::Matrix.new(4,1, 1,2,3,4)
      end
    end
  end

  describe "cloning" do
    mc = m4.clone

    it "can make a new copy of its matrix values" do
      mc.should eq m4
      mc._values.object_id.should_not eq m4._values.object_id
    end

    it "copies its dimensions" do
      mc.m.should eq m4.m
    end
  end

  describe "the cofactor matrix" do
    context "with a 2x2" do
      it "returns a copy of itself" do
        m1.cofactors.should eq m1
      end
    end

    context "with a larger matrix" do
      it "returns the cofactor matrix" do
        expected = CRT::Matrix.new(3,3, 56,12,-46, 28,-8,-2, -56,-26,18)
        CRT::Matrix.new(3,3, 1,2,6, -5,8,-4, 2,6,4).cofactors.should eq expected
      end
    end
  end

  describe "the inverse" do
    context "with an invertable matrix" do
      mat = CRT::Matrix.new(4,4, 6,4,4,4,
                                 5,5,7,6,
                                 4,-9,3,-7,
                                 9,1,7,-6)

      it "can return the inverse" do
        expected = CRT::Matrix.new(4,4, 167/530_f64,  -48/265_f64,  2/53_f64,   -4/265_f64,
                                   -14/265_f64,  -17/1060_f64, -7/53_f64,  109/1060_f64,
                                   -31/106_f64,  55/212_f64,   1/53_f64,   9/212_f64,
                                   13/106_f64,   3/106_f64,    3/53_f64,   -13/106_f64)
        mat.inverse.should eq expected
      end

      it "can determine that it is invertible" do
        mat.invertible?.should be_true
      end
    end

    context "with a non-invertable matrix" do
      mat = CRT::Matrix.new(4,4, -4,2,-2,-3,9,6,2,6,0,-5,1,-5,0,0,0,0)

      it "raises an exception if #invert is called" do
        begin
          mat.inverse
        rescue CRT::MatrixErrors::NotInvertible
          true.should be_true
          next
        end
        false.should be_true
      end

      it "can determine that it is not invertible" do
        mat.invertible?.should be_false
      end
    end
  end

  describe "the determinant" do
    context "with a 2x2 matrix" do
      it "returns the determinant" do
        m1.det.should eq -2
      end
    end

    context "with a larger matrix" do
      context "that is square" do
        it "returns the determinant" do
          CRT::Matrix.new(3,3, 1,2,6,-5,8,-4,2,6,4).det.should eq -196
          CRT::Matrix.new(4,4, -5,2,6,-8,1,-5,1,8,7,7,-6,-7,1,-3,7,4).det.should eq 532
        end
      end

      context "with is not square" do
        it "throws an exception" do
          begin
            CRT::Matrix.new(5,4).det
          rescue CRT::MatrixErrors::NotSquare
            true.should be_true
            next
          end
          false.should be_true
        end
      end
    end

    context "with a smaller matrix" do
      it "throws an exception" do
        begin
          CRT::Matrix.new(1,2).det
        rescue CRT::MatrixErrors::NotSquare
          true.should be_true
          next
        end
        false.should be_true
      end
    end
  end

  describe "computing a submatrix" do
    m5 = CRT::Matrix.new(3,3, 1,2,3,4,5,6,7,8,9)

    context "with a valid row/col removal" do
      it "can return a submatrix with the give row and col removed" do
        m5.submatrix(1,1).should eq CRT::Matrix.new(2,2, 1,3,7,9)
      end
    end

    context "with an invalid row" do
      it "raises an exception" do
        begin
          m5.submatrix(10,1)
        rescue CRT::MatrixErrors::DimensionOutOfRange
          true.should be_true
          next
        end
        false.should be_true
      end
    end

    context "with an invalid col" do
      it "raises an exception" do
        begin
          m5.submatrix(1,10)
        rescue CRT::MatrixErrors::DimensionOutOfRange
          true.should be_true
          next
        end
        false.should be_true
      end
    end
  end

  describe "addition" do
    context "with matching dimensions" do
      it "can add matrices" do
        (m1 + m2).should eq CRT::Matrix.new(2,2, 6,8,10,12)
      end
    end

    context "with mismatched dimensions" do
      it "raises an exception" do
        begin
          m1 + m3
        rescue CRT::MatrixErrors::MismatchedDimensions
          true.should be_true
          next
        end
        false.should be_true
      end
    end
  end

  describe "subtraction" do
    context "with matching dimensions" do
      it "can subtract matrices" do
        (m1 - m2).should eq CRT::Matrix.new(2,2, -4,-4,-4,-4)
      end
    end

    context "with mismatched dimensions" do
      it "raises an exception" do
        begin
          m1 - m3
        rescue CRT::MatrixErrors::MismatchedDimensions
          true.should be_true
          next
        end
        false.should be_true
      end
    end
  end

  describe "multiplication" do
    ex1 = CRT::Matrix.new(2,4, 1,2,3,4, 5,6,7,8)
    ex2 = CRT::Matrix.new(4,1, 1,2,3,4)

    it "can multiply by a scalar" do
      (ex1 * 2).should eq CRT::Matrix.new(2,4, 2,4,6,8, 10,12,14,16)
    end

    context "with matching dimensions" do
      it "can multiply matrices" do
        (m1 * m2).should eq CRT::Matrix.new(2,2, 19,22,43,50)
      end
    end

    context "with mxn*qxp where n=q" do
      it "can multiply matrices" do
        (m1 * m4).should eq CRT::Matrix.new(2,4, 11,14,17,20, 23,30,37,44)
        (ex1 * ex2).should eq CRT::Matrix.new(2,1, 30,70)
      end
    end

    context "with other, mismatched dimensions" do
      it "raises an exception" do
        begin
          ex2 * ex1
        rescue CRT::MatrixErrors::CannotMultiply
          true.should be_true
          next
        end
        false.should be_true
      end
    end
  end

  describe "division" do
    it "can divide by a scalar" do
      (CRT::Matrix.new(2,2, 1,2,3,4) / 4).should eq CRT::Matrix.new(2,2, 0.25,0.5,0.75,1.0)
    end
  end
end

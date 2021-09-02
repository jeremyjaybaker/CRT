module CRT
  struct Point < BaseVector
    def self.w
      1
    end

    def self.origin
      new Matrix.new([[0.0],[0.0],[0.0],[1.0]])
    end
  end
end

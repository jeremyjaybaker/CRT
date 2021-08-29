module CRT
  # Pre-defined matrices/templates. This mostly includes transform matrices
  # but also includes others like view_transform. Any hard-coded matrix should
  # probably be put here.
  module Matrices
    def self.identity
      Matrix.new([
        [1.0, 0.0, 0.0, 0.0],
        [0.0, 1.0, 0.0, 0.0],
        [0.0, 0.0, 1.0, 0.0],
        [0.0, 0.0, 0.0, 1.0]
      ])
    end

    def self.translation(x : Float64, y : Float64, z : Float64)
      Matrix.new([
        [1.0, 0.0, 0.0, x  ],
        [0.0, 1.0, 0.0, y  ],
        [0.0, 0.0, 1.0, z  ],
        [0.0, 0.0, 0.0, 1.0]
      ])
    end

    def self.scale(x : Float64, y : Float64, z : Float64)
      Matrix.new([
        [x,   0.0, 0.0, 0.0],
        [0.0, y,   0.0, 0.0],
        [0.0, 0.0, z,   0.0],
        [0.0, 0.0, 0.0, 1.0]
      ])
    end

    def self.rotation_x(rad : Float64)
      sin,cos = Math.sin(rad), Math.cos(rad)
      Matrix.new([
        [1.0, 0.0, 0.0,    0.0],
        [0.0, cos, sin*-1, 0.0],
        [0.0, sin, cos,    0.0],
        [0.0, 0.0, 0.0,    1.0]
      ])
    end

    def self.rotation_y(rad : Float64)
      sin,cos = Math.sin(rad), Math.cos(rad)
      Matrix.new([
        [cos,    0.0, sin, 0.0],
        [0.0,    1.0, 0.0, 0.0],
        [sin*-1, 0.0, cos, 0.0],
        [0.0,    0.0, 0.0, 1.0]
      ])
    end

    def self.rotation_z(rad : Float64)
      sin,cos = Math.sin(rad), Math.cos(rad)
      Matrix.new([
        [cos, sin*-1, 0.0, 0.0],
        [sin, cos,    0.0, 0.0],
        [0.0, 0.0,    1.0, 0.0],
        [0.0, 0.0,    0.0, 1.0]
      ])
    end

    def self.shear(a : Float64,       b : Float64 = 0.0, c : Float64 = 0.0,
                   d : Float64 = 0.0, e : Float64 = 0.0, f : Float64 = 0.0)
      Matrix.new([
        [1.0, a,   b,   0.0],
        [c,   1.0, d,   0.0],
        [e,   f,   1.0, 0.0],
        [0.0, 0.0, 0.0, 1.0]
      ])
    end

    def self.view_transform(from : Point, to : Point, up : Vector)
      forward = (to - from).as(Vector).normal
      left = forward.cross(up.normal)
      true_up = left.cross(forward)

      Matrix.new([
        [left.x,     left.y,     left.z,     0.0],
        [true_up.x,  true_up.y,  true_up.z,  0.0],
        [-forward.x, -forward.y, -forward.z, 0.0],
        [0.0,        0.0,        0.0,        1.0]
      ])
    end
  end
end

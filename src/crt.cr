require "./matrix"
require "./matrix_errors"
require "./matrices"
require "./base_vector"
require "./point"
require "./vector"
require "./color"
require "./ray"
require "./intersection"
require "./sphere"

module CRT
  # Used for floating point comparison "good enough" approximations
  EPSILON = 0.00001

  # Approximation to satisfy comparison error tolerance
  PI = 3.14159

  # Used to compare floats within a certain margin of error set
  # by EPSILON
  def self.equal?(a : Float64, b : Float64)
    (a-b).abs < EPSILON
  end
end

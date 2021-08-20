require "./matrix"
require "./base_vector"
require "./point"
require "./vector"

module CRT
  # Used for floating point comparison "good enough" approximations
  COMPARISON_EPSILON = 0.00001
  # Approximation good enough to satisfy comparison error tolerance
  PI = 3.14159

  # Used to equal? floats within a certain margin of error set
  # by EPSILON
  def self.equal?(a : Float64, b : Float64)
    (a-b).abs < COMPARISON_EPSILON
  end
end

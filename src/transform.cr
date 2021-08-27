module CRT
  # DRYs up classes/structs that can be transformed. To use, add `include CRT::Transform` under
  # the class name and define a #transform method. Example:
  # ```
  # private def transform(mat)
  #   @myclass_transform = @myclass_transform * mat
  # end
  # ```
  #
  # This method will automatically apply the correct transform matrix when a method like
  # #scale or #translate is called. If you need different functionality for specific
  # transformations, just override the needed method.
  module Transform
    def translate(x : Float64, y : Float64, z : Float64)
      transform(Matrices.translation(x,y,z))
    end

    def scale(x : Float64, y : Float64, z : Float64)
      transform(Matrices.scale(x,y,z))
    end

    def rotate_x(rad : Float64)
      transform(Matrices.rotation_x(rad))
    end

    def rotate_y(rad : Float64)
      transform(Matrices.rotation_y(rad))
    end

    def rotate_z(rad : Float64)
      transform(Matrices.rotation_z(rad))
    end

    def shear(a : Float64,       b : Float64 = 0.0, c : Float64 = 0.0,
              d : Float64 = 0.0, e : Float64 = 0.0, f : Float64 = 0.0)
      transform(Matrices.shear(a,b,c,d,e,f))
    end
  end
end

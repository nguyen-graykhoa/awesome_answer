class Rectangle
    attr_accessor(:x,:y)

    def initialize(x,y)
        @x = x
        @y = y
    end

    def area
        x * y
    end

end
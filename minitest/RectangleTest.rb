require 'minitest/autorun'
require './Rectangle.rb'

class RectangeTest < Minitest::Test
    def test_area
        #Arrange
        rectangle = Rectangle.new(3,4)
        #Act
        area = rectangle.area
        # Assert
        assert_equal(12, area)
    end
 
end


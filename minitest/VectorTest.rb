require 'minitest/autorun'
require './Vector.rb'

class VectorTest < Minitest::Test
    def test_length
        #Arrange
        vector = Vector.new(3,4)
        #Act
        length_of_vector = vector.length
        # Assert
        assert_equal(5, length_of_vector)
    end

    def test_to_s
        vector = Vector.new(3,4)
        assert_equal("Vector (3, 4)", "#{vector.to_s}")
    end
end
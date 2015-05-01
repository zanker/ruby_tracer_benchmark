class TestCase
  # Gives us a 676 method call chain
  CHARSET = ("aa" .. "zz").to_a

  CHARSET.each_with_index do |char, index|
    if char == CHARSET.last
      define_method "test_#{char}" do |first, second, third|
        if first == 2
          1
        elsif second == 3
          2
        elsif third == 3
          3
        else
          4
        end
      end
      
    else
      class_eval <<-RUBY
        def test_#{char}(first, second, third)
          test_#{CHARSET[index + 1]}(1, 2, 3)
          
          if first == 2
            1
          elsif second == 3
            2
          elsif third == 3
            3
          else
            4
          end          
        end
      RUBY
    end
  end
end
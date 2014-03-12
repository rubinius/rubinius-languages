# cat.rb
# Example code for learning about the debugger

class Cat
  def meow(duration=nil)
    duration ||= 5
    puts "me#{"o"*duration}w"
  end
end

Cat.new.meow

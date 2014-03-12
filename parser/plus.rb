# plus.rb
require "./plus.kpeg"

parser = Plus.new("1 + 0")

if parser.parse
  puts parser.result
end

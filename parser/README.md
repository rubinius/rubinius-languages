# Grammars and Parsers

## Generating a Parser

We're going to use kpeg to generate a parser. The language expresses addition
on integers. The kpeg description of the parser is in `plus.kpeg`:

```
# plus.kpeg
%% name = Plus

%% {
  attr_accessor :result
}

ws = /[ \t\n]+/

number = < /[0-9]*/ > { text.to_i }

expr = expr:e1 ws "+" ws expr:e2 { e1 + e2 }
     | number

root = expr:e { @result = e }
```

To generate the Ruby code for the parser, run the `kpeg` command as follows:

```
kpeg -f plus.kpeg -o plus.kpeg.rb
```

## Using the Parser

Once we have the parser, we can use it to parse source text. The following
simple script prints the result of parsing (and evaluating) "1 + 0":

```ruby
# plus.rb
require "./plus.kpeg"

parser = Plus.new("1 + 0")

if parser.parse
  puts parser.result
end
```

## Ideas

1. Look at [more kpeg
   examples](https://github.com/evanphx/kpeg/tree/master/examples).
1. Add other operations like multiplication.
1. Add parentheses.
1. Add variables like `a = 1`.

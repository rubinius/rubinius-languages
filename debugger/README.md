# Debuggers

Debuggers are invaluable tools that make normally hidden parts of the system
visible to us.

Some people think debuggers are unnecessary if the program has proper tests.
That opinion appears to assert that well tested programs won't have bugs,
hence debuggers are unnecessary.

However, debuggers are not just for finding bugs. In fact, in systems like
Smalltalk, the debugger is an integral part of the user interface.

## The Rubinius debugger

Rubinius has a "built-in" debugger. The debugger application is actually
provided by a separate gem, rubinius-debugger, but the virtual machine
provides the facilities that enable debugging. This means anyone could write a
debugger application for Rubinius.

## Using the Rubinius debugger

The following is a short tutorial for using the Rubinius debugger. We'll use
the following Ruby source code:

```ruby
# cat.rb
# Example code for learning about the debugger

class Cat
  def meow(duration=nil)
    duration ||= 5
    puts "me#{"o"*duration}w"
  end
end

Cat.new.meow
```

Follow the shell session below to perform some basic debugger actions:

```
$ rbx -Xdebug cat.rb

| Breakpoint: Rubinius::Loader#debugger at kernel/loader.rb:565 (50)
| 565:           Rubinius::Debugger.start
debug> b Cat#meow:7
* Unable to find class/module: Cat
| Would you like to defer this breakpoint to later? [y/n] y
| Deferred breakpoint created.
debug> c
| Resolved breakpoint for Cat#meow
| Set breakpoint 2: cat.rb:7 (+19)

| Breakpoint: Cat#meow at cat.rb:7 (19)
| 7:     puts "me#{"o"*duration}w"
debug> p duration
$d0 = 5
debug> s

| Breakpoint: String#*(num) at kernel/common/string.rb:64 (0)
| 64:     num = Rubinius::Type.coerce_to(num, Integer, :to_int) unless num.kind_of? Integer
debug> bt
| Backtrace:
|    0 String#*(num) at kernel/common/string.rb:64 (0)
|    1 Cat#meow at cat.rb:7 (30)
|    2 Object#__script__ at cat.rb:11 (43)
|    3 Rubinius::CodeLoader#load_script(debug) at kernel/delta/code_loader.rb:66 (52)
|    4 Rubinius::CodeLoader.load_script(name) at kernel/delta/code_loader.rb:152 (40)
|    5 Rubinius::Loader#script at kernel/loader.rb:649 (214)
|    6 Rubinius::Loader#main at kernel/loader.rb:831 (77)
debug> frame 5
| Rubinius::Loader#script at kernel/loader.rb:649 (214)
| 649:       CodeLoader.load_script @script, @debugging
debug> l
| 644:           end
| 645:         end
| 646:       end
| 647:
| 648:       set_program_name @script
| 649:       CodeLoader.load_script @script, @debugging
| 650:     end
| 651:
| 652:     #Check Ruby syntax of source
| 653:     def check_syntax
| 654:       parser = Rubinius::ToolSets::Runtime::Melbourne
debug> p @script
$d1 = "cat.rb"
debug> n
meooooow

| Breakpoint: Rubinius::Loader#main at kernel/loader.rb:831 (77)
| 831:       script
debug> bt
| Backtrace:
|    0 Rubinius::Loader#main at kernel/loader.rb:831 (77)
debug> c
```

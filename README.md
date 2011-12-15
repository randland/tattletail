Tattletail
=============

Introduction
-----------

Tattletail is a simple ruby debugging tool that provides Rubyists a way to tattle on methods.

Similar to 'poor mans' debugging with `puts` statements, Tattletail outputs whenever the method you tattle on gets called.

In addition, Tattletail will give you:

*    A call chain tree
*    The name of the method
*    The instance id of the method's object
*    The parameters passed into the method
*    The location of the Ruby file (and line number) from whence the method was called
*    A benchmark of the method's execution time

Requirements
-------

You need Ruby 1.9.2.

Tattletail is a work in progress and has not been known to work on rubies other than 1.9.2.

Installation
-------

Installing Tattletail is easy:

    gem install tattletail

Usage
-----

Using Tattletail has two steps:

1. Load it into your environment.
2. `tattle_on` a method.

Load it into your environment with:

    require 'tattletail'

Or, place it in your gemfile.

    gem 'tattletail'

`tattle_on` a method by simply adding `tattle_on <method_name>` somewhere in your class.

### Example:

Say we have a class that looks like this:

    class Sequences
      def fibonacci n
        return 1 if n <= 2
        fibonacci(n - 1) + fibonacci(n - 2)
      end
    end

And we wonder why it gets called so often, so we `tattle on` the fibonacci method.

    class Sequences
      def fibonacci n
        return 1 if n <= 2
        fibonacci(n - 1) + fibonacci(n - 2)
      end
      tattle_on :fibonacci
    end

Then we call this method in irb (or better yet [pry][2]):

    pry(main)> Sequences.new.fibonacci 4

And Tattletail outputs:

    ─┬─ #1 #<Sequences:0x007fa8eaa79960>.fibonacci(4) called
     │         /gems/tattletail-0.0.3/lib/tattletail/demo.rb:18
     │
     ├──┬─ #2 #<Sequences:0x007fa8eaa79960>.fibonacci(3) called
     │  │         /gems/tattletail-0.0.3/lib/tattletail/demo.rb:18
     │  │
     │  ├──┬─ #3 #<Sequences:0x007fa8eaa79960>.fibonacci(2) called
     │  │  │         /gems/ruby-1.9.2-p290@tattletail/gems/tattletail-0.0.3/lib/tattletail/demo.rb:18
     │  │  └─ #3 #<Sequences:0x007fa8eaa79960>.fibonacci(2) ⊢ 1
     │  │         0.0000 sec
     │  │
     │  ├──┬─ #4 #<Sequences:0x007fa8eaa79960>.fibonacci(1) called
     │  │  │         /gems/ruby-1.9.2-p290@tattletail/gems/tattletail-0.0.3/lib/tattletail/demo.rb:18
     │  │  └─ #4 #<Sequences:0x007fa8eaa79960>.fibonacci(1) ⊢ 1
     │  │         0.0001 sec
     │  │
     │  └─ #2 #<Sequences:0x007fa8eaa79960>.fibonacci(3) ⊢ 2
     │         0.0017 sec
     │
     ├──┬─ #5 #<Sequences:0x007fa8eaa79960>.fibonacci(2) called
     │  │         /gems/ruby-1.9.2-p290@tattletail/gems/tattletail-0.0.3/lib/tattletail/demo.rb:18
     │  └─ #5 #<Sequences:0x007fa8eaa79960>.fibonacci(2) ⊢ 1
     │         0.0000 sec
     │
     └─ #1 #<Sequences:0x007fa8eaa79960>.fibonacci(4) ⊢ 3
            0.0029 sec

More Information
---------

Issues? Questions? Open an [Issue][1] on github.

If you need more usage examples, they can be found in [lib/tattletail/demo.rb][3]

Contributing
------------

Want to contribute? Great!

1. Fork it.
2. Create a branch (`git checkout -b my_feature`).
3. Commit your changes (`git commit -am "Added Awesomeness"`).
4. Push to the branch (`git push origin my_feature`).
5. Create an [Issue][1] with a link to your branch.
6. Enjoy a refreshing Diet Coke and wait.


[1]: http://github.com/randland/tattletail/issues
[2]: https://github.com/pry/pry
[3]: https://github.com/randland/tattletail/blob/master/lib/tattletail/demo.rb

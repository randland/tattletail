Tattletail
=============

Tattletail provides Rubiests a way to tattle on methods.

All you have to do is install Tattletail, and `tattle on` any method.

Tattletail will give you:

*    A call chain tree
*    The name of the method
*    The instance id of the method's object
*    The parameters passed into the method
*    The location of the ruby file (and line number) from whence the method was called
*    A benchmark of the method's execution time

Requirements
-------

All you need is ruby 1.9.2

Tattletail is a work in progress and has not been known to work on rubies other than 1.9.2.

Installation
-------

    gem install tattletail

Usage
-----

    require 'tattletail'

Or, place it in your gemfile.

    gem 'tattletail'

Once Tattletail is in your environment every object can tattle on its methods, or instance methods.

### Example:

Say we have a class that looks like this:

    class Sequences
      def fibernachi n
        return 1 if n <= 2
        fibernachi(n - 1) + fibernachi(n - 2)
      end
    end

And we wonder why it gets called so often, so we `tattle on` the fibernachi method.

    class Sequences
      def fibernachi n
        return 1 if n <= 2
        fibernachi(n - 1) + fibernachi(n - 2)
      end
      tattle_on :fibernachi
    end

Then we call this method in irb (or better yet [pry][2]):

    pry(main)> Sequences.new.fibernachi 4

And Tattletail outputs:

    ─┬─ #1 #<Sequences:0x007fa8eaa79960>.fibernachi(4) called
     │         /gems/tattletail-0.0.3/lib/tattletail/demo.rb:18
     │
     ├──┬─ #2 #<Sequences:0x007fa8eaa79960>.fibernachi(3) called
     │  │         /gems/tattletail-0.0.3/lib/tattletail/demo.rb:18
     │  │
     │  ├──┬─ #3 #<Sequences:0x007fa8eaa79960>.fibernachi(2) called
     │  │  │         /gems/ruby-1.9.2-p290@tattletail/gems/tattletail-0.0.3/lib/tattletail/demo.rb:18
     │  │  └─ #3 #<Sequences:0x007fa8eaa79960>.fibernachi(2) ⊢ 1
     │  │         0.0000 sec
     │  │
     │  ├──┬─ #4 #<Sequences:0x007fa8eaa79960>.fibernachi(1) called
     │  │  │         /gems/ruby-1.9.2-p290@tattletail/gems/tattletail-0.0.3/lib/tattletail/demo.rb:18
     │  │  └─ #4 #<Sequences:0x007fa8eaa79960>.fibernachi(1) ⊢ 1
     │  │         0.0001 sec
     │  │
     │  └─ #2 #<Sequences:0x007fa8eaa79960>.fibernachi(3) ⊢ 2
     │         0.0017 sec
     │
     ├──┬─ #5 #<Sequences:0x007fa8eaa79960>.fibernachi(2) called
     │  │         /gems/ruby-1.9.2-p290@tattletail/gems/tattletail-0.0.3/lib/tattletail/demo.rb:18
     │  └─ #5 #<Sequences:0x007fa8eaa79960>.fibernachi(2) ⊢ 1
     │         0.0000 sec
     │
     └─ #1 #<Sequences:0x007fa8eaa79960>.fibernachi(4) ⊢ 3
            0.0029 sec

It's as easy as that!

More Information
---------

Issues? Questions? Open an [Issue][1] on github.

If you need more examples, they can be found in [lib/tattletail/demo.rb][3]

Contributing
------------

Want to contribute? Great!

1. Fork it.
2. Create a branch (`git checkout -b my_feature`)
3. Commit your changes (`git commit -am "Added Awesomeness"`)
4. Push to the branch (`git push origin my_feature`)
5. Create an [Issue][1] with a link to your branch
6. Enjoy a refreshing Diet Coke and wait


[1]: http://github.com/randland/tattletail/issues
[2]: https://github.com/pry/pry
[3]: https://github.com/randland/tattletail/blob/master/lib/tattletail/demo.rb

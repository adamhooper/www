---
id: 7
title: 'Ruby''s Object#respond_to?: String or Symbol?'
slug: 7-ruby-s-object-respond_to-string-or-symbol
date: 2009-07-28T19:27:41Z
---

When calling
<a href="http://ruby-doc.org/core/classes/Object.html#M000331"><code>Object#respond_to?</code></a>,
use a Symbol when you can. Ruby’s internal method lookup uses “IDs,”
which correspond to programmer-visible Symbols.

To get an ID from a Symbol, the Ruby interpreter uses a bit-shift,
`SYM2ID`:

    #define SYM2ID(x) RSHIFT((unsigned long)x,8)

To get an ID from a String, on the other hand, it does this:


    static ID
    str_to_id(str)
        VALUE str;
    {
        VALUE sym = rb_str_intern(str);

        return SYM2ID(sym);
    }

…and since that calls `SYM2ID` anyway, and we assume the shortest path
between two points is a straight line, your code will be more efficient
if it uses a Symbol.

Be wary of [premature
optimization](http://www.c2.com/cgi/wiki?PrematureOptimization), too:
this tip is really to justify a convention, not to encourage you to
rewrite all your code.

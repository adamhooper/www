---
id: 2
title: 'Working With and Around FormBuilder'
slug: 2-working-with-and-around-formbuilder
date: 2008-11-11T06:19:05Z
---

My current work is entirely focused on [Ruby on
Rails](http://rubyonrails.org); and once you put Rails into focus, a lot
of well-intended, badly-implemented designs peer back at you. Today’s
topic: `FormBuilder`.

`FormBuilder` is a class most Rails users use transparently and most
Rails users do not realize exists. It is the class of object returned by
the `form_for()` and `fields_for()` helper methods.

Rails’s `FormBuilder` code looks like it was abandoned before being
completed, and it suffers from abysmal documentation. Best practices,
aside from being undocumented, do not cover all use cases—or even common
use cases. In fact, best practices are downright nonexistent.
Fortunately, all that can change with about 20 lines of well-placed
code.

### What `FormBuilder` does well

In your templates (depicted here in
[Haml](http://haml.hamptoncatlin.com) instead of Rails’s default, ERb,
as Haml is less sucky), `FormBuilder` shines with simple fields:


    - form_for(@thing) do |f|
      %p
        = f.label(:name, 'Name:')
        = f.text_field(:name)
      %p
        = f.label(:description, 'Description:')
        %br/
        = f.text_area(:description)

Here, `f` is the `FormBuilder` instance. It provides the `label()`,
`text_field()` and `text_area()` methods.

### What `FormBuilder` does badly

Inevitably, in the course of a project, you will want to use more than
text fields and date fields. And here, `FormBuilder` falls flat. For
instance, a select field might look like this:


      %p
        = f.label(:thing_type_id, 'Type:')
        = f.select(:thing_type_id, ThingType.all(:order => :name).collect{ |t| [ t.name, t.id ] }, :include_blank => 'None')

This verbose amalgamation of complicated code and simple markup is even,
with no apparent embarassment, suggested in the Rails API documentation.

But even `select()` is elegant compared to other common solutions
`FormBuilder` supposedly provides. Writing a functional `date_field()`,
needed for virtually any serious Rails project, is a nightmare; compound
fields are nonexistent; and, most common and worst of all, there is no
way to specify, for instance, “title fields should look like *this*”:
the very Don’t Repeat Yourself principle Rails fans so avidly embrace.

### Mediocre Solutions

Rails plugins may ease the pain, but they almost never do exactly what
you want. Even if you find a perfect `date_field()`, you are only
postponing an inevitable need for a more general solution.

Helper methods can work around some of `FormBuilder`, but if you resort
to your own system of helper methods, you end up essentially engineering
your own mini-framework of form helpers. The problem here is the
unintuitive divide (what is `FormBuilder` and what is custom?) and a
very inconsistent method signature (that is, the types and orders of
parameters). And if you do not plan things out ahead of time, your
helper code which began as a helper or two will end as a confusing mess.

Developers also get tempted to use Rails’s alternate tagging library
methods, such as `text_field_tag()`, `select_tag()`, and other
non-incumbered helpers. The problem with these is that they do not do
the wonderful things `FormBuilder` does: automatically figure out
element names and IDs, for instance, magically calculate fields’ initial
values, or (prior to Rails 2.2) output valid HTML. These methods should
be avoided when building a form for a model.

The funny thing is, `FormBuilder` actually *does* solve all these
problems, *almost*. It really does get 95% of the way there. This
article presents the last 5%.

### How `FormBuilder` works

`FormBuilder`, implemented mostly in
`action-pack/lib/action_view/helpers/form_helper.rb` (but spread into
`date_helper.rb` and `form_options_helper.rb` in a textbook example of
“when *not* to use Ruby’s class-reopening feature”), is implemented with
three main pieces:

First, the helper methods: `ActionView::Helpers::FormHelper` defines
several methods which are available to every view: `text_field()`,
`text_area()`, `select()`, and so on. Most of them follow a simple
calling convention:


      def something_field(object_name, method, options = {})

And here’s the magical part: if `options[:object]` is set, the helper
will call `options[:object].send(method)`: it will use the actual object
to determine the initial value of the field.

Second, `ActionView::Helpers::FormBuilder` (which is not a helper at
all): essentially, `FormBuilder` holds the object you are building a
form for and serves as a proxy to the helper methods. It redefines every
helper method with its own version:


      def something_field(method, options = {})

`FormBuilder` uses its own `object_name` and `object` methods, so that
when your template calls:


    = f.text_field(:name, :size => 15)

`FormBuilder` (in the above example, `f`) passes the call through as:


    = text_field(f.object_name, :name, :size => 15, :object => f.object)

Lastly, `InstanceTag`: an implementation detail which may strike you at
first as over-engineered, but upon further inspection rubs off as
sideways-engineered at best and upside-down-engineered the rest of the
time. Try to avoid calling its methods or modifying it whenever
possible.

### What We Want

We want a simple way to add new types of fields to `FormBuilder`:
perhaps, extending the above examples, a `thing_type_field()` or a
`date_field()`. I will showcase both below.

### Implementation

I shy away from plugins and I encourage others to act the same way. If
you do not understand this code, you should not use it: that would be
applying my solutions to your problems, which only works if you have the
exact same problems as I do, which is unlikely. Continue on your merry
way until you reach the aforementioned impasses, and use this guide as
an *aid* in solving your problems.

That said, here is my solution:

Create the directory `lib/forms/` and add a file,
`lib/forms/application_helper.rb`, and leave it nearly empty for now:


    module Forms::ApplicationHelper
      # Helper methods go here
    end

At the top of `app/helpers/application_helper.rb`, include it:


    module ApplicationHelper
      include Forms::ApplicationHelper
      #... leave whatever was here before ...
    end

Create a custom `FormBuilder`, in `lib/forms`, in a file called
`lib/forms/application_form_builder.rb`:


    class Forms::ApplicationFormBuilder < ActionView::Helpers::FormBuilder
      # Copied from FormBuilder. FormBuilder looks like it has some bright
      # engineering ideas but never finished implementing them. This *should*
      # be automated by defining "self.field_helpers", but it's used before
      # this class is loaded.
      Forms::ApplicationHelper.instance_methods.each do |selector|
        src = <<-end_src
          def #{selector}(method, options = {})
            @template.send(#{selector.inspect}, @object_name, method, objectify_options(options))
          end
        end_src
        class_eval src, __FILE__, __LINE__
      end

      private

      def objectify_options(options)
        @default_options.merge(options.merge(:object => @object))
      end
    end

The above code is copied, almost word-for-word, out of Rails’s original
`FormBuilder`.

Finally, we want to use our own `ApplicationFormBuilder` instead of
Rails’s default, so add the file
`config/initializers/application_form_builder.rb` with the following
contents:


    ActionView::Base.class_eval do
      def self.default_form_builder
        Forms::ApplicationFormBuilder
      end
    end

Restart your Rails application (this is the last time—a subtle bonus)
and we are now using our new-and-improved `ApplicationFormBuilder`. At
the moment, it behaves exactly like Rails’s regular `FormBuilder`: it
maintains all the great features, adding no overhead. But now we can
extend it!

### A better `date_field`

When engineering, always determine what the customer wants (which should
be easy here, because you are the customer). In my case, I want to write
this:


    %p
      = f.label(:start_date, 'Start Date:')
      = f.date_field(:start_date)

Now, let’s make this work!

I use [jQuery](http://jquery.com/) for all my JavaScript needs, which is
fantastic because it lets me work without HTML IDs and it lets me remove
100% of my JavaScript code from my templates, which is good because code
does not belong in templates. There are a couple of jQuery date-select
plugins which border on acceptable; let us use the one which comes as
part of the jQuery-UI download, `ui.datepicker.js`.

Our first hurdle: all these JavaScript date-picker fields submit text
(for example, `"Nov 10, 2008"`) which the model does not expect. We will
need to edit our model to allow reading and writing a text
representation. So let’s take our model, for instance,
`app/models/thing.rb`


    class Thing
      # ... typical model stuff ...

      def start_date_string
        d = self.start_date
        d.blank? ? nil : d.strftime('%b %d %Y')
      end

      def start_date_string=(value)
        d = nil
        begin
          d = Date.parse(value)
        rescue ArgumentError
          # d = nil
        end

        self.start_date = d
      end
    end

(In a real project, this behaviour should be extracted into a mix-in.)

Now we have `Thing::start_date_string()` and
`Thing::start_date_string=()`, which behave like `Thing::start_date()`
and `Thing::start_date=()` except they allow human-readable strings that
can be submitted via HTML forms.

We should add the necessary JavaScript includes, as well, in
`app/views/layouts/application.html.haml` (or, as the case may be,
`app/views/layouts/application.html.erb`—or whatever layout you happen
to be using), in the header:


    = javascript_include_tag(['vendor/jquery.js', 'vendor/jquery.ui.all.js', 'date_field.js'])

To tie our HTML into jQuery (since, as mentioned above, we write no
JavaScript in our HTML), our templates will need to output text fields
with a special class attached. Let us arbitrarily choose the HTML class,
`date_field`.

Create `public/javascripts/date_field.js` with the following contents:


    $(document).ready(function() {
      $('input.date_field').datepicker({
        // Add options here...
        dateFormat: 'M d yy'
      });
    });

This JavaScript, when loaded, will turn any HTML `input` with class
`date_field` into an interactive date selector.

Now, let us use our magical `ApplicationFormBuilder` to create the
missing piece of the puzzle, by adding the following to
`lib/forms/application_helper.rb`:


      def date_field(object_name, method, options = {})
        options = options.reverse_merge(:size => 12)
        if options[:class].blank?
          options[:class] = 'date_field'
        else
          options[:class] += ' date_field'
        end
        method = "#{method}_string".to_sym
        text_field(object_name, method, options)
      end

Presto! Your template should work now. If you have forgotten, your
template looks like this:


    - form_for(@thing) do |f|
      %p
        = f.label(:start_date, 'Start Date:')
        = f.date_field(:start_date)

And internally, that behaves as follows:

1.  The template calls `form_for(`@`thing)` to create a new
    `ApplicationFormBuilder`, `f`. (The initializer we wrote specifies
    `ApplicationFormBuilder` instead of the regular `FormBuilder`.)
2.  The template calls `f.date_field(:start_date)` (and maybe passes
    optional parameters, such as an HTML class or style).
    `ApplicationFormBuilder::date_field()` is not the helper you wrote:
    it is a new method, generated automatically because you wrote the
    helper method.
3.  `ApplicationFormBuilder::date_field()` calls the helper you wrote,
    `date_field(:thing, :start_date)`.
4.  `Forms::ApplicationHelper::date_field()` calls
    `text_field(:thing, :start_date_string, :object => thing, :size => 12, :class => 'date_field')`
5.  `FormHelper` (the Rails helper) creates the text field, with the
    `date_field` HTML class.
6.  When the page loads, jQuery selects all text fields with the
    `date_field` HTML class and calls `datepicker()` on them, turning
    them into date pickers.

Whew, a lot of work, right? yes. But here are the advantages:

-   We can pick another jQuery-style date-picker implementation, and all
    we need to change is `public/javascripts/date_field.js`.
-   We can change the HTML completely, for instance reverting to Rails’s
    three-dropdown-box behaviour, by simply changing
    `lib/forms/application_helper.rb`.
-   It is easy to unit-test the helper, the template, and the
    JavaScript, since each has an isolated and distinct role.
-   Views receive the real benefits:
    -   There is no bloat in a simple call to `f.date_field(:method)`:
        we remain readable and concise.
    -   Site-wide changes to date field behaviour can transpire without
        a need to edit templates.

As for drawbacks? This procedure is certainly complicated, so some
people may prefer to just install a Rails plugin and be done with it. I
have tried a few date selector plugins and found them all lacking in one
way or another compared with this implementation, but your mileage may
vary.

### A better `select()`

While ranting above about `FormBuilder` shortcomings, I produced this
piece of code, which the Rails API documentation shockingly presents as
exemplary.


      %p
        = f.label(:thing_type_id, 'Type:')
        = f.select(:thing_type_id, ThingType.all(:order => :name).collect{ |t| [ t.name, t.id ] }, :include_blank => 'None')

What do we, the customer (template writer), *want* to type? Certainly
not all that, since we may have `ThingType` selectors elsewhere in our
application and we are almost guaranteed to need to change the code
within as our application evolves. Helper methods are a common but
unsatisfactory compromise. What we *really* want is this:


      %p
        = f.label(:thing_type_id, 'Type:')
        = f.thing_type_field(:thing_type_id)

And the implementation? Easy: Just add this to
`lib/forms/application_helper.rb`:


      def thing_type_field(object_name, method, options = {})
        select(object_name, method, ThingType.all(:order => :name).collect{ |t| [ t.name, t.id ] }, options.reverse_merge({:include_blank => 'None'}))
      end

Advantages:

-   Our template is simple.
-   We reuse code and ensure consistency across the site by only writing
    our model query once.
-   Because the model query code is now in a helper (where it belongs)
    and not in the template (where it does not), it can (and should) be
    easily split into multiple lines and have more logic added.

Disadvantages:

-   We lose the nice `html_options` parameter in the `select()` method’s
    signature, which is inconsistent across the Rails API but useful
    nonetheless. It is straightforward to pass a `:html_options` item
    within our `options` hash to work around this problem.

### A Nested Object Field

Rails is unhelpful when you want to include a nested object in your
form. The best you can do is render a partial, but I find that annoying
because it melds interface with implementation. How about this:


      def foo_field(object_name, method, options = {})
        foo = options[:object] && options[:object].send(method) || Foo.new
        fields_for("#{object_name}[#{method}]", foo) do |f|
          render(:partial => '/foo/form', :object => f)
        end
      end

And because at this point all your form partials use `FormBuilder`
exclusively and never rely upon an @`object` or @`foo` or anything like
that, this works without a hitch.

### Parting Thoughts

This guide is the result of many of hours of hard work with
`FormBuilder`, and I hope it helps save others that time. If you have
any questions, comments, or even completely different and possibly
better solutions, I would love to hear them.

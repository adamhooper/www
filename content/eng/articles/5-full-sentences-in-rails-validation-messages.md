---
id: 5
title: 'Full Sentences in Rails Validation Messages'
slug: 5-full-sentences-in-rails-validation-messages
date: 2009-07-09T15:35:21Z
---

This article assumes a rudimentary understanding of [Rails
Internationalization](http://guides.rubyonrails.org/i18n.html) (or at
least a working knowledge of Rails and a vague awareness that strings
meant to be displayed to users can be stored outside of models,
controllers, and views).

I will explain why Rails’s validation messages are incorrect, and I will
provide a simple monkey-patch which can let you write less restricted
validation messages. In the process, you should become more comfortable
with translations and less comfortable with several Rails methods.

### Rationale

There is a golden rule in i18n (“internationalization”): [do not use
string
concatenation](http://www.gnu.org/software/gettext/manual/gettext.html#Preparing-Strings).

#### Why String Concatenation Breaks…

An example: I once worked on a website which lists organizations in both
English and Swahili. In English, one could write, “found 16 companies”;
in Swahili, this might translate to, “masharika 16 yamekutanwa” (if I
studied my grammar correctly).

A programmer might be tempted to write:

    s = I18n.t('Found') + ' ' + number + ' ' + I18n.t('company', :count => number)

with a translations file containing

    en:
      company:
        one: company
        other: companies
      found: found

But in Swahili, the best this strategy could produce is, “Tumeyakutana
16 masharika,” which is completely out of order.

Instead, our intrepid programmer should write:

    s = I18n.t('found n companies', :count => number)

with a translations file containing

    en:
      found n companies:
        zero: found no companies
        one: found one company
        other: 'found {{count}} companies'

In English, the output is identical. At first glance, one might find the
translation file repetitive (and clearer to read). But the real gain is
that our program can now be translated to any language (depending on the
I18n backend). We can now write a Swahili version of the string (excuse
my grammar if I get these wrong):

    sw:
      found n companies:
        zero: masharika sifuri yamekutanwa
        one: sharika moja limekutanwa
        other: 'masharika {{count}} yamekutanwa'

Problem solved! And we learned a valuable moral: do not use string
concatenation to build sentences.

#### … Even in a Single Language

Another example: suppose an ActiveRecord validation produces an error.
Rails will normally return a string such as “title: can’t be blank”. You
may want to adjust that message to, “Please enter a title.”

ActiveRecord does not support this use case, despite the fact that
ActiveRecord validations are advertised as i18n-aware. Why? Because
ActiveRecord, at least in Rails 2.3, has a nasty tendency to build
sentences through string concatenation: an absolute no-no.

I can help you fix those validation messages.

### fix_active_record_validations_full_messages.rb

`ActiveRecord::Errors` has a method called `full_messages` which returns
a list of all error messages on an object. In Rails 2.3, `full_messages`
is the unlikely arbiter of error messages. Let us examine the original:

    ...
        def full_messages(options = {})
          full_messages = [] 

          @errors.each_key do |attr|
            @errors[attr].each do |message|
              next unless message

              if attr == "base"
                full_messages << message
              else 
                attr_name = @base.class.human_attribute_name(attr)
                full_messages << attr_name + I18n.t('activerecord.errors.format.separator', :default => ' ') + message 
              end  
            end  
          end  
          full_messages
        end 

See the `+` signs next to `I18n.t`? Those are string concatenations:
definitely off-limits. The funny thing is, by the time `full_messages`
is called, all those messages have already been translated (in
`ActiveRecord::Errors#add`).

Getting confused? That is not your fault. Suffice it to say, validations
in Rails 2.3 are crufty, confusing, and ultimately incorrect.

The fix is simple: just remove the fancy logic from
`ActiveRecord::Errors#full_messages`.

In your Rails project, put this in
`config/initializers/fix_active_record_validations_full_messages.rb`:

    # Ensures that when we pass a :message parameter to our validations, that
    # message is a sentence (and not something to be prefixed by the column
    # name). Rationale: ActiveSupport::Inflector is in over its head on this
    # one.
    #
    # So instead of:
    #   validates_presence_of :name, :message => 'should not be blank'
    # Use:
    #   validates_presence_of :name, :message => 'Name should not be blank'
    #
    # If, however, you just use:
    #   validates_presence_of :name
    # The behavior will remain unchanged.
    if RAILS_GEM_VERSION =~ /^2\.3/
      ActiveRecord::Errors.class_eval do
        # Remove complicated logic
        def full_messages
          returning full_messages = [] do
            @errors.each_key do |attr|
              @errors[attr].each do |msg|
                full_messages << msg if msg 
              end 
            end 
          end 
        end 
      end 
    end

### config/locales/en.yml

The default Rails 2.3 error messages do not interpolate the attribute
name: as we saw above, that is done in Rails 2.3’s flawed
`ActiveRecord::Errors#full_messages`.

The sensible thing to do is correct the messages which, I think everyone
should agree, are incorrect (because—you guessed it!—they are not full
sentences).

Write this in `config/locales/en.yml` (or wherever your translations
take place):

    en:
      activerecord:
        errors:
          messages:
            # Default messages: complete sentences
            inclusion: "{{attribute}}: is not included in the list"
            exclusion: "{{attribute}}: is reserved"
            invalid: "{{attribute}}: is invalid"
            confirmation: "{{attribute}}: doesn't match confirmation"
            accepted: "{{attribute}}: must be accepted"
            empty: "{{attribute}}: can't be empty"
            blank: "{{attribute}}: can't be blank"
            too_long: "{{attribute}}: is too long (maximum is {{count}} characters)"
            too_short: "{{attribute}} is too short (minimum is {{count}} characters)"
            wrong_length: "{{attribute}}: is the wrong length (should be {{count}} characters)" 
            taken: "{{attribute}}: has already been taken"
            not_a_number: "{{attribute}}: is not a number"
            greater_than: "{{attribute}}: must be greater than {{count}}"
            greater_than_or_equal_to: "{{attribute}}: must be greater than or equal to {{count}}"
            equal_to: "{{attribute}}: must be equal to {{count}}"
            less_than: "{{attribute}}: must be less than {{count}}"
            less_than_or_equal_to: "{{attribute}}: must be less than or equal to {{count}}"     
            odd: "{{attribute}}: must be odd"
            even: "{{attribute}}: must be even"

These are the default Rails 2.3 validation messages with the `attribute`
thrown in. With this `en.yml` and the above-mentioned monkey-patch to
`ActiveRecord::Errors#full_messages`, Rails 2.3 will superficially
behave identically to a non-monkey-patched version.

(Personally, I take this opportunity to make Rails’s default messages
more human-friendly, by removing colons, adding periods, and rephrasing
some sentences.)

### Why

With our groundwork in place, Rails gets out of the way and lets us
write what we want.

For instance, suppose we have an `Article` with a `:body` and a
`:title`, both validated using `validates_presence_of`, with an extra
`validates_length_of` on the `:title`. We can add the following in
`config/locales/en.yml`, within the
`en: { active_record: { errors: ... } }` section (alongside `messages`):

    ...
          models:
            article:
              attributes:
                body:
                  blank: Please enter body text for your article.
                title:
                  blank: Your article is desperately seeking a title.
                  too_long: "Your article's title cannot exceed {{count}} characters. Give it a trim."

And there you have it: full sentences in validation messages.

### The Last Word

I started this article under the guise of internationalization, but my
actual code and use case are purely English. This is because *you should
not build sentences using string concatenation*, no matter which
language you speak (or, for that matter, in which language you program).

This article should help you avoid string concatenation in one part of
Rails 2.3; there are many other errors in Rails 2.3 and perhaps even in
your own code, and I hope you feel better-equipped to remedy those
problems as well.

### Appendix: Other Confusing Rails Methods

Here is a list of Rails methods which you should think before using:

-   `ActiveSupport::Inflector#titleize` (Never use this: it does not
    translate, and even in English it will fail you every time. Even the
    string used as an example in the method’s documentation, “Man From
    The Boondocks,” is titleized incorrectly by this method.)
-   `ActiveSupport::Inflector#humanize` (Never use this unless you are
    rewriting Rails’s internals. Maybe you want
    `ActiveRecord::Base#human_attribute_name` and
    `ActiveRecord::Base#human_name`?)
-   `ActiveSupport::Inflector#ordinalize` (If you mean to translate your
    application to non-English and you use `ordinalize`, you will need
    to override this method or define a replacement.)
-   `ActiveSupport::CoreExtensions::String::Inflector#singularize` and
    `ActiveSupport::Inflector#singularize` (Never `singularize`
    user-input strings, but feel free to `singularize` hard-coded
    strings such as class names and method names.)
-   `ActiveSupport::CoreExtensions::String::Inflector#pluralize` and
    `ActiveSupport::Inflector#pluralize` (Never `pluralize` user-input
    strings, but feel free to `pluralize` hard-coded strings such as
    class names and method names.)
-   `I18n::Backend::Simple#pluralize` (The `Simple` I18n backend is only
    correct for English and a few other languages (by
    happenstance)—pluralization rules are different in different
    languages. If you later translate to a language with more complex
    pluralization rules than “zero/one/many”, you will need to replace
    the I18n backend for a more complete `pluralize` method, but you
    will not need to change the files which *called* `pluralize`.)
-   `ActionView::Helpers::TextHelper#pluralize` (This is the helper you
    can call from your views. Never use it: it does not translate to
    other languages, and even in English you should be writing special
    strings instead of displaying “0” and “1”, as a matter of style.)

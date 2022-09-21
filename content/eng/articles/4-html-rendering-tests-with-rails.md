---
id: 4
title: 'HTML Rendering Tests with Rails'
slug: 4-html-rendering-tests-with-rails
date: 2009-04-16T19:06:22Z
---

### The Problem

Picture the situation: 3pm on deploy day, after fully testing that your
Rails application outputs the proper HTML, you run Capistrano and bring
up the newest version of your beautiful website. An uneventful half-hour
passes, after which you are told by your CEO that in Internet Explorer
7, a certain component of your web page is misaligned by 20px. While
investigating further, you find your supposedly-vertical lists of
checkboxes are being rendered in a diagonal line by Internet Explorer 6.
Your deploy has transformed your once-perfect website into an
unprofessional disaster.

You blow off dinner plans, fix bugs, validate all other pages on all
major browsers, and finally, around 8pm, relax. At this point, the
question is not so much, “why?” as it is, “how can we make sure this
never *ever* happens again?”

Testing manually is simply too time-consuming (especially if you support
many browsers). You want to go The Rails Way and automate your tests.
How can you automatically render your HTML on various browsers and
ensure the output looks right?

### Assumptions

-   You are using Ruby on Rails.
-   You want to verify every pixel on every browser/platform in your
    tests.
-   You want your test to fail if any pixel on any browser/platform
    changes from what you verified.
-   Different browsers/platforms will very rarely produce exact,
    pixel-by-pixel matches, and the differences should be validated
    manually.
-   You do not mind if the HTML structure changes, so long as the
    rendered output does not change.
-   Tests should be easy to write and edit.

### Overview

We need a test framework which can render any Rails partial or template
using any browser/platform. Though we only intend to test our own
templates, we are actually implicitly forced to test our models and the
browsers we support, as shown in this diagram:

![HTML Request Lifecycle](http://adamhooper.com/images/eng/html-rendering-tests-request-lifecycle.png "HTML Request Lifecycle")

### Implementation

The trickiest part of implementation is finding a way to automatically
gather web browser output. This is especially difficult because:

-   Web browsers were historically not designed to render off-screen, so
    “render a PNG of a web page” is generally a difficult task involving
    very different code on each browser.
-   Rendering is a very slow operation, compared to, say, parsing an
    HTML document’s DOM structure.
-   Some web browsers are mutually exclusive (for instance, Internet
    Explorer 7 and Internet Explorer 8) and cannot usually appear on the
    same computer.

A distributed testing environment is necessary, either through physical
or virtual machines. It will look something like this:

![HTML Rendering Distributed Computing Layout](http://adamhooper.com/images/eng/html-rendering-tests-distributed-layout.png "HTML Rendering Distributed Computing Layout")

This leaves plenty of programs for us to write:

-   The “Test Runner”
-   The “Render Server”
-   The “Thumbnailing Program” (which is different for each
    browser/platform)

#### Render Server, Thumbnailing Programs

I have decided to bundle (platform-specific) thumbnailing programs with
the (cross-platform) render server. The project is hosted on GitHub:
[html_to_png_server](http://github.com/adamh/html_to_png_server), which
includes compiled versions but currently only handles IE6/7 on Windows
and Firefox 3 on GNOME. (New thumbnailing programs, while trivial to
plug into the render server code, are difficult to implement.)

The server accepts a POST request with HTML data, and it returns a PNG
response. The URL determines which thumbnailing program (i.e., browser)
to use for rendering. What a wondrous black box!

Visit <http://github.com/adamh/html_to_png_server> for details.

#### Test Runner

The test runner is written in Ruby and hosted on GitHub:
[html_render](http://github.com/adamh/html_render).

It contains a Rails-agnostic component, which is simply a client to the
Render Server, and a Rails-specific testing component.

Visit <http://github.com/adamh/html_render> for details.

### Your Render Test Framework

The idea is for Rails rendering tests to be as simple as possible to
write, while incorporating your own application’s specific needs. You,
the test automation engineer, will have two tasks:

-   Application-specific (or, if you feel creative,
    sub-application-specific) HTML-preparation and render server
    configuration: your project-specific framework.
-   Actual tests which use your framework.

#### Your Project-Specific Framework

Here is a sample framework, in which we have decided the following:

-   Tests are stored in `RAILS_ROOT/test/render/`
-   Tests are invoked by running `ruby test/render_test.rb`
-   You will render on `winxp-ie6.local`, `winxp-ie7.local`, and
    `ubuntu-ff3.local`

Create the file `test/render_test.rb` with the following contents:

    require File.dirname(__FILE__) + '/test_helper'

    require 'html_render/render_test/rails'

    class RenderTest < ActiveSupport::TestCase
      extend HTMLRender::RenderTest::Rails::TestCaseDefinitions

      PREFIX = File.join(File.dirname(__FILE__), 'render')
      SERVERS = {
        :winxp_ie6 => 'http://winxp-ie6.local:20558/ie',
        :winxp_ie7 => 'http://winxp-ie7.local:20558/ie',
        :ubuntu_ff3 => 'http://linux-ff3.local:20558/ff3_linux'
      }

      class ApplicationRenderTest < HTMLRender::RenderTest::Rails::RenderTest
        def css
          @css ||= File.open(File.join(File.dirname(__FILE__), '..', 'public', 'stylesheets', 'application.css')) { |f| f.read }
        end

        def javascript
          '' # We're not ambitious enough to test our JavaScript just yet
        end
      end

      define_tests(PREFIX, :servers => SERVERS, :base_class => ApplicationRenderTest)
    end

#### Your Tests

To test the partial `/foos/_foo.html.erb` (or `.haml`), create the file
`test/render/foos/_foo/basic/setup.rb` with the following contents:

    def locals
      { foo: Foo.new }
    end

(Yes, that is the entire test.)

Here, we name the test `basic`: we may want to create several tests of
the same partial, and for those we would replace “basic” with something
else. The path, `foos/_foo`, implicitly specifies that we mean to test
`app/views/foos/_foo.html.erb` (or `.haml`, as the case may be). Tests
may define `locals`, `assigns`, `css`, `javascript`, or any helper
methods deemed necessary. Behind the scenes, the contents of `setup.rb`
will be appended to a subclass of `ApplicationRenderTest`. Any methods,
up to and including `html` (the only method the testing framework
actually uses) may be overridden.

### Running Your Test Suite

First, download
[html_to_png_server](http://github.com/adamh/html_to_png_server)
(specifically, `html_to_png_server.jar`) to each rendering machine and
start the server on each machine:

    java -jar html_to_png_server.jar

Next, on the test runner computer (which holds your Rails project code),
install the [html_render](http://github.com/adamh/html_render) gem:

    sudo rubygems install adamh-html_render --source http://gems.github.com

Now you can run the test suite from your Rails project directory:

    ruby test/render_test.rb

(This command could just as easily be made into a Rake task, of course,
and included as part of `rake test`.)

All your render tests will fail: the expected images have not been
defined yet! But each render has actually taken place, and the results
are now viewable.

#### Making Tests Pass

Look in `test/render/foos/_foo/basic`. Where before you only had
`setup.rb`, you will now have a `run/` subdirectory with `html.html`,
`winxp_ie6.png`, `winxp_ie7.png`, and `ubuntu_ff3.png`.

Here is the manual validation part: make sure each of those images looks
the way you want it. If it does not, you will need to fix the partial
(or, if you made a mistake settings up the framework, you will need to
fix the stylesheets you are supplying in `ApplicationRenderTest`).

Assuming the images look correct, you can set the expected value. Choose
the best-looking image and copy it to `canonical.png` (in the same
directory as `setup.rb`). Now, should you add any new servers to your
testing framework, their output will be compared pixel-by-pixel with the
image in `canonical.png` (and the test will fail if the pixels do not
match). Typically, `canonical.png` will be chosen from a Firefox server.
(Not that I’m opinionated against Internet Explorer or anything.)

Now, if you run your test again, you will probably find that it still
fails. While your `ubuntu_ff3.png` matches `canonical.png` as expected,
the Internet Explorer images are not identical to `canonical.png` and so
they trigger the failure. This failure is expected and healthy. To mark
the images as valid, create a `valid/` subdirectory in the same
directory as `setup.rb` and copy `winxp_ie6.png` and `winxp_ie7.png`
into it.

In the end, your single test’s folder will look like this:

-   `test/render/foos/_foo/basic/setup.rb`
-   `test/render/foos/_foo/basic/run/html.html`
-   `test/render/foos/_foo/basic/run/ubuntu_ff3.png`
-   `test/render/foos/_foo/basic/run/winxp_ie6.png`
-   `test/render/foos/_foo/basic/run/winxp_ie7.png`
-   `test/render/foos/_foo/basic/canonical.png`
-   `test/render/foos/_foo/basic/valid/winxp_ie6.png`
-   `test/render/foos/_foo/basic/valid/winxp_ie7.png`

…and your test will pass. (Until you change the partial, that is: try
editing it and watch the test fail!)

#### Test Policy Considerations

When adding your tests to version control, ignore the `run/`
subdirectories: the test only really comprises `setup.rb`,
`canonical.png`, and the images within `valid/`. (The `run/` directory
can be considered a temporary directory, though it is useful enough that
the `html_render` test framework leaves it behind.)

You may also choose to never set a `canonical.png`. I chose to include
it because it seems idealogically appropriate and it will help when
developing a nice user interface for the test runner.

### Summary

You now have a test framework which validates, with pixel-perfection,
the way your partial/template is output from major web browsers. It can
work at any detail level, from a single input box to your whole home
page. You can also write tests of your HTML-producing helpers,
independently of any actual templates (by overriding `html` in the
test’s `setup.rb`).

The system is somewhat fragile: all render servers must be running
html_to_png_server.

The system is somewhat slow: your render test suite will take
approximately as long to run as it takes your slowest render server to
render each partial.

But despite the system’s faults, you now confidently catch those irksome
20px Internet Explorer hasLayout issues before your boss does.

### Looking Forward

This system is currently prototypical. Here, I discuss some problems I
intend to solve.

The test suite is difficult to manage, with its masses of images in
several directories. A graphical front-end to this large directory
structure is a huge priority and should make the process of fixing tests
much easier.

More challenging, the process of writing a test is not as seamless as it
could be. I envision a point-and-click interface running on top of the
actual Rails application, though of course this is easier said than
done.

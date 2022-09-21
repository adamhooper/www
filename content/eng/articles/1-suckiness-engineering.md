---
id: 1
title: 'Suckiness Engineering'
slug: 1-suckiness-engineering
date: 2008-11-02T06:24:23Z
---

Everything sucks.

This is a website dedicated to engineering and programming: to learning
why computers do what they do, to understanding how to trick them into
doing what you want, and to making the world (or at least, the computer
programs therein) better.

Yet nobody seems to realize everything sucks, so I cannot resist a
diatribe.

### Computers Suck

Before computers were even invented, scientists already knew there are
some problems computers can never solve. (They all stem from the halting
problem: writing Program A to run Program B and determine whether
Program B has gotten into an infinite loop: Program A, an idiot like all
computer programs, is doomed to sit idly by and twiddle its thumbs while
Program B goes crazy and explodes.)

Computers are very bad at certain tasks, too, like organizing an
airplane-confined salesperson’s itinerary. They know what to do, yet
they insist on taking millions of years in which to do it: a rather
inconvenient delay, since they are bound to break before they finish.

But it might be a good thing computers are so inept. If computers could
organize efficient itineraries, they would also break all our encryption
algorithms (since if you knew how to organize efficient itineraries you
could use that knowledge to decipher encrypted text).

### Computer Programs Suck

A current computer can run billions of calculations every second, and
yet it still takes a minute from when I turn it on to when I have Google
open. I implicitly run this same test on every computer I use, with
different suites of programs (written by Apple, Microsoft, or freedom
fighters), and the story is always the same. Wait, wait, wait. Except
for the times when something breaks and I never get my Google prompt
after all.

A lot of things can break, too: viruses can latch onto your computer,
physical defects can infest it, or, more enraging, you can click on that
one pixel the developers thought you would never click on, drag your
mouse over three pixels to some other pixel they assumed you would miss,
and let go. I do house calls to fix computer problems from time to time,
and the most common annoyance I see is the Microsoft Windows taskbar
floating to the left of the screen or toolbars in Microsoft Word
floating nowhere in particular.

And then… the crashes. Oh, Lord, the crashes.

Then, not to be forgotten, the inevitable “security bug” dilemma, which
can render your wonderful web server into a spam-sending turd in the
span of five minutes. Most of these bugs are extremely stupid; yet
because of the halting problem, computers cannot help us find them all.

### User Interaction Sucks

“But wait!” you say. “What about Google? Google Search doesn’t suck,
does it?”

Yes, it does. If Google Search did not suck there would be no need for
the “Search” button because the “I’m Feeling Lucky” button would always
take you exactly where you want. In fact, there would be no button at
all, because there would be no text field, because Google would already
*know* what you want. Even better, you would never need to open the
Google website at all, as Google would simply infuse the knowledge into
your mind a millisecond before you even realize you want it.

Keyboards and mice and user interfaces and web pages are the first signs
of imperfection in our computer programs. They make the user *do*
something, which sucks because the user wants the *computer* to do it.

I hate using computers, and you should, too. But assuming you are a
programmer programming programs for non-programmers, never forget that
your users hate using computers even more.

### Where Engineering Comes In

Everything about computers sucks. But some aspects suck *less*. And
therein lies my approach to software engineering. This is a rehash of
textbook processes, yet I have never seen it written down with this
wording: probably because textbook writers consider the word “suckiness”
taboo.

To write a program:

1.  Define perfection. Because computers suck, perfection does not
    necessarily involve computers. Perfection involves users getting
    what they want with a minimum of hassle.
2.  Define and measure how far your program is from perfection: your
    “suckiness”, if you will.
3.  Remove as much suckiness as you can as quickly as you can.
4.  Repeat steps 1-3 until you have overspent your resources or your
    program’s suckiness level is below your acceptance threshold.

Good engineering is all about cycles. The cycles can have any length
(1-2 week cycles seem to work in several contexts) and you can repeat as
many times as you like. You can alter requirements (Step 1) and their
priorities (Step 2) as often as you like, and you can run as many or as
few cycles as you like.

In the spirit of negativity, here is what happens if you try to skip the
above steps:

1.  If you neglect to define what you are trying to program, then you
    have implicitly decided to program “something”. And your “something”
    does exactly that, which is annoying because you realize soon
    afterwards that you meant for it to do what you *want* it to do, and
    meanwhile it is off “something”-ing. Then you need to change it.
2.  If you neglect to prioritize, you spend ten days working on Internet
    Explorer 4 compatibility or something equally unimportant (for your
    purposes), leaving the important work unfinished and untested.
3.  If you neglect to code, your code does not get written. More subtly
    (because more people seem to ignore it), if you neglect to *test*
    your code, your program’s suckiness does not change because you have
    no proof that the suckiness indeed did decrease as outlined in Steps
    1 and 2. (*How* you test is up to you, but rest assured, you *are*
    testing.)
4.  If you never repeat your cycle, you never incorporate new insights
    into your process. If a piece of code turns out to be difficult
    (Step 3), you may want to reprioritize it (Step 2) or even drop it
    completely (Step 1). Conversely, if you have hit your goals, you can
    *stop* repeating and go outside and play, confident that your
    program does not suck as much as, say, remaining indoors.

It may seem cynical, but this loop is very effective at
suckiness-removal. And that is what software engineering is all about.

Perfect programs belong to computer programmers. Proofs that they do
cannot exist belong to computer scientists. Real programs for real
people are, whether you like it or not, whether you *realize* it or not,
generated through software engineering.

### “Why are you telling me what to do?”

I am not telling you what to do. I am showing you what you do *already*.

Everything from basement-tinkered tools to bank security software is
built in this same manner. Not just with computers: with everything we
create. In fact, it can be carried to things we do *not* create.
Evolution, for instance, is a constant striving towards the perfection
of remaining alive, with priority number one being having lots of
babies.

Don’t be a wooly mammoth. Engineer your software.

---
title: "Test2 Manual - The Perl and Raku Foundation"
url:   "/test2-manual.html"
---
Test2 ManualBy Makoto Nozaki
March 29, 2016

The Grants Committee has received one grant proposal for
the March round. Before the Committee members vote, we
would like to solicit feedback from the Perl community on
the proposal.
Review the proposal below and please comment here by
April 9th, 2016. The Committee members will start the
voting process following that and the conclusion will be
announced by April 16th.

Test2 Manual

-   Name:Chad \'Exodist\' Granum.
-   Amount Requested: USD 2,000

Synopsis
I am proposing to write a Test2 manual. The Test2
distribution already has very complete module
documentation. The manual will build off the individual
module documentation and provide very valuable
integration and usage details.
Benefits to the Perl Community
Test tool development has been held back for a very
long time now. Test2 should unblock a lot of areas
related to testing, but only if people can figure out
how to use it. This manual should make current and
future test developments accessible to all perl
developers.
Deliverables
-   Test2::Manual A brief introduction and table of contents.
-   Test2::Manual::Tooling This section will cover writing test tools.
    This would be a root document with several other page links. \* The
    name of the manual page, and the manual layout will need to be
    finalized.
-   Test2::Manual::Maintenance This section will cover maintaining Test2
    itself. This will be a root document pointing to pages that explain
    the internals, and how they work together. \* The name of the manual
    page, and the manual layout will need to be finalized.

Project Details
Test2 is intended to be the new core of perl testing
tools. Test2 itself is now on cpan, and Test::Builder
will be updated to use Test2 under the hood (I have an
ongoing grant for this that is near-completion).
Something this important needs serious documentation.
This
manual will explain how all the bits and pieces work
together. The manual will target 3 specific
audiences:
-   Test Tool Authors This section of the manual will cover people who
    want to write new tools or that use Test2 under the hood. This is
    probably the most important audience as it will be necessary if
    tools are going to be compatible with each other.
-   Test2 Maintainers This section of the manual will cover people who
    wish to participate in Test2 development directly. This is important
    to reduce the bus factor (which is very close to 1 currently).

Inch-stones
For test authors:
-   Migrating from Test::Builder Conversion notes and examples for
    people moving from Test::Builder. This will detail how tools might
    have changed, what is gone, and introduce some new or replacement
    concepts.
-   Simple OK tool This is the most basic tool you can write, and is
    valuable for explaining the key concepts universal to all Test2
    tools.
-   The Test2 API This
    covers [Test2::API](https://metacpan.org/pod/Test2::API), and all
    the functionality it exposes.
-   The \'Context\' object Explain what the context object is, why it is
    important, and how to use it effectively.
-   The \'Hub\' object and API Explanation of the hub objects and how
    they work.
-   Custom Hubs How to write a hub subclass (essential for Subtest like
    tools).
-   Custom event types How to write an event.
-   Custom output formatters How to write an output formatter.
-   Writing IPC drivers How to write a custom IPC Driver.

For Test2 maintainers:
-   Component map Map of all Test2 components.
-   Basic building blocks Explanation of low-level infrastructure such
    as Test2::Util::HashBase.
-   How the \'Context\' works Detailed overview of the Context object,
    and implementation details.
-   The hub stack What the hub stack is, and why it is important.
-   The IPC system internals How IPC works, and more importantly how it
    can fail.
-   Utilities The utilities library, and important implementation
    details.
-   Performance Notes Key information about where changes can severely
    impact performance.

Project Schedule
I can start as soon as the grant is approved. The work
will be done on free evenings and weekends as time
allows.
Completeness Criteria
The manual will be included in a Test2 release on cpan.
The manual will have all expected sections, with no
significant gaps or TODO sections.
Bio
My name is Chad Granum. I am known as Exodist on CPAN.
I have spent several years writing Perl for work and for
fun. For most of my time in Perl I've specialized in
unit testing tools. [Fennec](https://metacpan.org/pod/Fennec) is a good example of my previous work.
In January of 2014 Michael Schwern transferred the
Test-Simple dist and all of its components to me. He
felt I was the best person to carry the project forward.
Since then I have reached out to the rest of the
community to be sure I was carrying the project forward
in the best interests of all.

### Cateogries: [Grants](grants.html)

Comments
[Dave Rolsky](https://blog.urth.org/)
| March 30, 2016 2:32am
I'm all for this grant. I've been working with
Test2 a fair bit recently and I could have used this sort
of docs. Chad has been very responsive on IRC, but I
suspect long term his time is better spent working on this
manual than answering all my questions ;)

Chad Granum | March 30, 2016 1:46pm
Oops,the part that reads 'will target 3 specific
audiences' should be 'will target 2 specific
audiences'.

[Alfie John](https://www.fastmail.com/)
| April 6, 2016 2:42am
I have been using Test2 quite a bit recently, and
have found it excellent and extremely useful - a value to
Perl!
A manual with more coverage than the current
docs on how the various bits and pieces work together
would be a need to have in the long term for Perl's
testing ecosystem.

[Ron Savage](http://savage.net.au/)| April 6, 2016 3:34am
As an early adopter of Test::Stream, I know the
current docs don't quite fit my expectations, so I support
the grant to present the docs differently.

Graham Ollis | April 6, 2016 3:41am
Having written a couple of Test::Stream modules
(which I plan on switching to Test2) and played around
with Test2, I agree the module documentation is quite
good, but the bigger picture provided by a Test2::Manual
and friends is missing and would help developers who are
just starting out with Test2 a lot.

Joshua Keroes | April 12, 2016 6:50pm
I have been porting [https://metacpan.org/pod/Scientist](https://metacpan.org/pod/Scientist) with Lance and James to Test2. It has been smooth
sailing but would have been smoother had there been an
overview to take in the Test2 ecosystem. It's a big place!
More docs would be very useful.

Florian Ragwitz | April 15, 2016 5:52pm
I would love to see this grant happen.The typical
style of module API documentation often makes it hard for
readers to understand overarching concepts and doesn't
always make it easy to figure out how to apply the APIs to
any particular use case.
I've seen ::Manual-style
documentation make a big difference on other projects
before (Moose, Catalyst, DBIx::Class, etc), and I think
the Test2 project would benefit a lot from a real manual
as well, especially considering how central to the Perl
ecosystem it is (or soon will be), and how many different
use cases the project needs to support.
Chad
obviously understands Test2 very well, and seems to have a
proven track-record of writing high-quality
documentation.
I'm looking forward to using Test2 in
my day-to-day work, and I think the proposed manual would
help me a lot with that.

[Jason Ketola](https://www.maxmind.com/en/home)
| April 15, 2016 7:24pm
We at MaxMind would very much welcome this
manual.
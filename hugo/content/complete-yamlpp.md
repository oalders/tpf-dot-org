---
title: "Complete YAML::PP - The Perl and Raku Foundation"
url:   "/complete-yamlpp.html"
---
Complete YAML::PPThe Grants Committee has received the following grant
proposal for the July/August round. Before the Committee
members vote, we would like to solicit feedback from the
Perl community on the proposal.
Review the proposal
below and please comment here by August 14th, 2017. The
Committee members will start the voting process following
that and the conclusion will be announced approximately
one week after public comments.

### Complete YAML::PP
Name:
Tina Müller

### Amount Requested:
USD 2,500

### Synopsis
I have been working on a new YAML Pure Perl Parser,
already on CPAN as [YAML::PP](https://metacpan.org/pod/YAML::PP). It aims to parse [YAML 1.2](http://yaml.org/spec/1.2/spec.html).
The existing YAML frameworks in Perl all lack
important features and don't support YAML 1.2. I will
continue development of YAML::PP so that it's able to
parse all valid syntaxes (with some minor exceptions). I
will complete the Loader to support tags. I will add a
Dumper and Emitter.
I will add test cases to the
cross framework [YAML Test Suite](https://github.com/yaml/yaml-test-suite) and continue developing the [YAML Test Matrix](http://matrix.yaml.io/) to compare all frameworks.

Benefits to the Perl Community
While JSON has become popular as a simple format to
exchange data, there are still a lot of use cases for
YAML. Imagine how verbose an Ansible Playbook would look
in JSON. Comments are an important feature, and Aliases
come in very handy sometimes.
While [PyYAML](http://pyyaml.org/) still only supports YAML 1.1, it has at least
support for safe loading (See below). [Python Ruamel](https://pypi.python.org/pypi/ruamel.yaml) aims to support 1.2.
I find it very
unfortunate for Perl, that there is no support for YAML
1.2, for safe loading and for booleans.
It would be
a nice opportunity for Perl to have a framework that
supports all that.
Since the YAML Test Suite is
supposed to become the number one source to write tests
in any language, it can promote the new Perl
framework.
Since I'm aiming for a portable
implementation, this framework might also be easily
ported to Perl 6, which currently has no full support
for YAML, although there is some development going
on.

Project Details
The current state of YAML in Perl is as follows:
YAML.pm
* Based on YAML 1.0. It can't do trailing comments and
has problems with a lot of valid 1.1 and 1.2
syntaxes.

YAML::XS
* Based on libyaml and the most recommended module. It
supports YAML 1.1. It diverges from the spec for
several edge cases.

YAML::Syck
* Supports YAML 1.0. It has problems with a lot of
valid YAML 1.1 and 1.2 syntaxes.

Safe Loading
* YAML.pm and YAML::XS have no possibility to disable
loading into objects. That means if you load an
untrusted YAML file, it can be a security hole.
YAML::Syck supports disabling that via
"LoadBlessed".

Booleans
* The three mentioned modules don't support booleans.
If you need to dump your data into JSON or let it be
validated, booleans get lost (turned into 1 or 0).
Only YAML::XS provides a limited way of keeping
booleans when roundtripping.

Separate Parser and Constructor
* The mentioned modules can only be used as complete
Loaders. There is no possibility to put your own
Loader on top of a parser.

You can check which test cases these modules are
passing or failing: [YAML Test Matrix](http://matrix.yaml.io/)
I have been going over a number of RT tickets for
YAML.pm at the end of 2016, creating and merging Pull
Requests from patches and writing Pull Requests
myself.
I'm working a lot with Ingy döt Net, one of the
creators of YAML, and Felix Krause, developer of
NimYAML, on the YAML Test Suite and on RFCs for creating
YAML 1.3.
I created the YAML Test Matrix to show the results of
the tests for a growing number of YAML frameworks, based
on Ingy's Docker image for [YAML Editor](https://github.com/yaml/yaml-editor).
I started to implement my own parser YAML::PP in 2017,
and it currently passes most of the tests with the
exception of Flow Style. The loader can already load
YAML documents that the parser can parse. It supports
booleans and aliases, but no tags yet.
I'm currently transforming it into a tokenizer which
allows correct syntax highlighting, making it also
easier to spot errors.
I want it to be able to do roundtrips including
comments at some point.
At the Perl Toolchain Summit 2017 in Lyon I have been
working together with Ingy to create a concept of a new
API for YAML loading. The goal is to integrate YAML::PP
into that API.
Ingy and I started to implement the API in [YAML::Perl](https://metacpan.org/pod/YAML::Perl), using YAML::PP as a backend.
I also started to implement the new Loader API
in [Perl 6](https://github.com/yaml/yaml-perl6), currently using the [libyaml binding](https://github.com/yaml/yaml-libyaml-perl6) originally written by Curt Tilmes as a
backend.

Deliverables and Inch-Stones
Complete YAML::PP::Parser
A couple of features are still missing from the
parser
Flow Style
* This is the biggest part. Flow Style is not indent
based, and some rules are different than in block
style. (I estimate 40h.)

Flow Nodes as mapping keys
* This is also a major part, because stacking of parser
events is necessary until the parser knows if it's a
mapping key or a node. (30h)

Line and Column Numbers for error messages
* Currently no information about line and column is
saved. (20h)

YAML::PP::Loader/Constructor

Implement loading
of Tags and blessing into objects
(20h)

Provide
a possibility for safe loading
(10h)

Ideally
provide a way to only load certain tags

Write
YAML::PP::Emitter
(20h)

Write
YAML::PP::Dumper/Deconstructor
(20h)

Add
more test cases to YAML Test Suite

Show also
results of invalid examples in YAML Test Matrix
(10h)

Make
the code integrateable into the new YAML Loader API

Keep
in touch with the development of YAML 1.3
specification
* Implement the current parser in a way that makes it
easy to add support for YAML 1.3

Talk about this project at TPC in Amsterdam
* My talk and my published slides will explain why YAML
currently is difficult to implement. I also gave this
talk at the German Perl Workshop in Hamburg.

Project Schedule
I can start to work on this immediately and almost
full time over the next two months.

Completeness Criteria
I release YAML::PP with the features implemented I
mentioned above. The parser shall pass most of the tests
in YAML Test Suite, with the exception of edge cases.
Since the spec is often not very clear, there are some
cases where it is unclear what should be the correct
behavior, or what behavior actually makes sense. These
edge cases are usually not relevant for real use cases and
are easy to avoid. I will look at other frameworks and
find out the most common behavior.
The Emitter should
be able to transform every test input into valid YAML. The
style (quotes/block scalar, spaces/newlines etc.) might
still differ from the test suite.
The Loader/Dumper
API, and especially the Parser and Emitter API, might not
be completely fixed at the end of this grant. Ingy can me
help me out here, supposed he's got time, and I need
potential user feedback.
Ingy also offered to review
the work.
I appreciate new test cases, bug reports,
patches and co-maintainers, and I want to keep maintaining
this module in the future.

Bio
I wrote my first Perl code in 1998 and have been in
touch with the Perl Community since about 2001.
I
already have two parsing modules on CPAN.
One is
HTML::Template::Compiled, one of the fastest (and still
feature rich) pure perl templating modules that gains its
speed from compiling to perl code.
The other is
Parse::BBCode, which is unique among the Perl BBCode
modules, in that it provides a parse tree, it allows
addition of own tags, it tries to correct invalid BBCode
instead of simply dying, and it's fast.
YAML is a bit
more complicated to parse, because it's indentation based,
but I like solving programming puzzles.
I do a lot of
pair programming with Ingy and I'm also in contact with
Felix Krause, so I have two people available who know the
Spec.

YAML Details
If you are wondering about terminology, here is a
short explanation:
Loading YAML can be divided into
two steps.
The Parser parses a Stream and returns a
list of parsing events. The Constructor then takes these
events, decides about numbers, tags, booleans and
aliases/anchors and constructs a data structure.
Vice
versa, Dumping YAML can be divided into deconstructing and
emitting. The Deconstructor creates a list of emitter
events from a data structure. The Emitter creates a YAML
Stream from these events.
If you keep these things
separate, it allows you to use the language independent
Test Suite to test your parser. It also makes debugging
and maintaining easier. Also you can use a different
parser backend, for example a libyaml based one.

### Categories: [Grants](http://perlfoundation.weebly.com/grants.html)

Comments
Karen Etheridge (ether) |  August 8, 2017
4:19pm
Tinita has been doing some great work on YAML
over the last few years and I fully support this grant
to allow her to continue.
As YAML::Tiny is shipped
with core perl (wrapped as CPAN::Meta::YAML) and used in
cpan installers and by PAUSE, I am particularly excited
about the improvements to test suites to ensure
compatibility between backend implementations.

lichtkind | August 11, 2017 3:07pm
Tina is one of the most experienced Perlers around
and does stuff faithfully for the long time benefit of the
German Perl Community since years. On top she is easy to
communicate with and a careful listener.
YAML is
still a big thing and thats whyt Perl should have
excellent support of. This proposal is at good as it
gets.

Reini Urban | August 13, 2017 10:44am
If it would be put into core then yes. All the
existing YAML modules are severely broken, incompatible,
limited and insecure by default.
Tini's work will at
least solve the problem on the PP (pure-perl side), but
core still uses YAML (totally broken) and CPAN::Meta::YAML
(limited and deviating).
Ingy is not willing (or not
able) to fix his his two modules. He rather stated to work
on YAML 1.3 instead. So this will at least fix the PP
side, I'm working on the XS side.
And honestly only
one YAML (XS) module needs to be in core. The PP variant
is only useful for CPAN backports to older versions.
To
summarize: CPAN defaults to YAML, Meta defaults to its own
bastard. Recommended for CPAN is to use YAML::Syck and for
Meta there's no urgent need for anything.

Ingy dot Net | August 14, 2017 6:33pm
Tina has been the point person for all the YAML
modules in Perl for the past 2 years. We work together on
all the various YAML projects, but she's the one actively
fielding questions on IRC, GitHub and CPAN/RT; fixing bugs
and making releases.
She is one of the 5 most
knowledgable people in the world about YAML, and
definitely #1 of that group in being dedicated to the
success of Perl.
I am sure that she will be
completing this work regardless, but I know that she is at
a special place right now where this grant would help her
focus completely on the work. I expect only the best from
her efforts.
Ingy (creator of YAML)

Larry Leszczynski | August 14, 2017 7:41pm
I'm excited to see this work happening. I have been
emailing with Ingy lately about some needs to have line
numbers and comments retained during parsing, and the new
tokenizing and parsing approach should be able to support
that (and I'm willing to help out with that where I can).
We use YAML extensively at my current employer (Grant
Street Group) and the ongoing improvements will be of
great use.
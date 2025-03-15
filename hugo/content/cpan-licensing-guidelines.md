---
title: "CPAN Licensing Guidelines - The Perl and Raku Foundation"
url:   "/cpan-licensing-guidelines.html"
---
CPAN Licensing GuidelinesThis page provides some guidelines for including copyright
and license notices in CPAN modules. The intention is that
these guidelines can be used to create a code-kwalitee tool
to check CPAN modules for license and copyright notics.
The
guidelines are marked as "required" (really necessary),
"suggested" (strongly recommended), and "if you want to"
(speaks for itself).
Important Note: If code is
licensed under a license other than an Artistic License or
“the same terms as Perl”, that license may require that you
to include additional material and notices.
-   The README file is the primary place for copyright and license
    notices. This is required for every CPAN distribution.

-   The first line of the README should be a copyright notice in the
    form of:

<package name> is Copyright (C) <years>,
<author name>.
The name in the notice should be
the name of the copyright holder for the module. If the
module is a compilation of the works of many authors, only
the name of the copyright owner of the compilation needs to
be included in this first line notice. The form of the name
used can be the owner’s formal legal name, or a less formal
version of the name or in the case of an individual, a
nickname (e.g. "Abigail" or "chromatic"), as long as the
nickname or shortened form is one that’s recognized in the
community—meaning that interested parties would be able to
find the person or organization under that name without much
difficulty.
-   Then, under a \"LICENSE INFORMATION\" heading, add
    the required license notice:

This [library|program|code|module] is free software; you can
redistribute it and/or modify it under the same terms as
Perl 5.10.0. For more details, see the full text of the
licenses in the directory LICENSES.
Always identify a
specific version of Perl, rather than the general statement
"same terms as Perl itself". If you're using a license other
than a license used for a specific Perl package, always
identify the version number of the license:
This
[library|program|code|module] is free software; you can
redistribute it and/or modify it under the terms of the
Artistic License 2.0. For details, see the full text of the
license in the file LICENSE.
-   It\'s suggested that you include a warranty disclaimer in the
    license notice. The warranty disclaimer should be consistent with
    the warranty disclaimer in the license that applies to your package.
    For instance, if the Artistic License 2.0 applies:

This program is distributed in the hope that it will be
useful, but it is provided “as is” and without any express
or implied warranties. For details, see the full text of the
license in the file LICENSE.
-   Also in the README file, right under the license notice, it
    is suggested to include a list of files that have different
    copyright owners or that are subject to different licenses. As noted
    earlier, licenses other than one of the Artistic Licenses may
    require that you include additional notices and material.

Files with different licenses or copyright holders:
<filename>: Copyright (C) <years>, <author
name>. <license statement>
For example:
lib/Foo/Bar.pm:
Copyright (C) 2005-2008, Stan Shunpike. The file is licensed
under the terms of the GNU Lesser General Public License
2.1. See <http://www.gnu.org/licenses/lgpl-2.1.html>.
-   Also required is license metadata in the META.yml file that
    identifies the relevant license, for example:

license: perl
or:
license: artistic2
-   It\'s suggested that you include the full text of the license in a
    file called LICENSE, or for dual licensing (e.g. Artistic/GPL as in
    \"the same terms as Perl\"), include both licenses in a directory
    called LICENSES. If you don\'t include the full text of the license
    in the module, then provide a URL instead (either full-text or URL
    is required), changing the sentence in the license notice to:

For more details, see the full text of the licenses at
<http://www.perlfoundation.org/artistic_license_1_0>,
and <http://www.gnu.org/licenses/gpl-2.0.html>.
URLs
can change, so it's best to use a reliable URL like The Perl
Foundation site, the Free Software Foundation site, or the
Open Source Initiative site (opensource.org).
-   It\'s suggested that you include a copyright notice at the top of
    every file in your CPAN distribution.

Copyright (C) <years>, <owner>.
-   It\'s suggested that you include a license and copyright notice in
    the POD documentation of the main module in your CPAN distribution,
    so it can be easily found by people reading the documentation on a
    site like search.cpan.org. This copyright and license notice should
    appear under a heading \"COPYRIGHT AND LICENSE\", and the license
    notice should be an exact copy of the license notice text you
    included in the README file. You should not include copyright
    information under the AUTHOR heading. For example:

AUTHOR <author name> <email> COPYRIGHT AND
LICENSE Copyright (C) <years>, <author name>.
This [library|program|code|module] is free software; you can
redistribute it and/or modify it under the same terms as
Perl 5.10.0. For more details, see the full text of the
licenses in the directory LICENSES. This program is
distributed in the hope that it will be useful, but without
any warranty; without even the implied warranty of
merchantability or fitness for a particular purpose.
-   If you want to, you may include the \"COPYRIGHT AND LICENSE\" POD
    section in every module file.
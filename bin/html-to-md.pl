#!/usr/bin/env perl

use v5.40;

use utf8;
use Mojo::DOM            ();
use Mojo::Util           qw( trim );
use HTML::Restrict       ();
use Path::Iterator::Rule ();
use Path::Tiny           qw( path );

my $rule = Path::Iterator::Rule->new;               # match anything
my $next = $rule->iter('www.perlfoundation.org');
while ( defined( my $file = $next->() ) ) {
    if ( $file !~ m{\.html\z} ) {
        next;
    }
    say $file;
    convert_file( path($file) );
}

sub convert_file ($file) {
    my $html_content = $file->slurp_utf8;
    my $basename     = $file->basename('.html') . '.md';

    # If the file is missing the leading underscore, none of the other pages in
    # the folder will be built.
    if ( $basename eq 'index.md' ) {
        $basename = '_index.md';
    }
    my $target = path('hugo/content')->child($basename);
    $target->remove;
    my $url = $file->basename;

    # Parse the HTML with Mojo::DOM
    my $dom = Mojo::DOM->new($html_content);

    # Locate the div with the class 'wsite-section-content'
    my $divs        = $dom->find('div.wsite-section-content');
    my $title       = $dom->at('title')->text || die 'no title found';
    my $frontmatter = <<"END_FRONTMATTER";
---
title: "$title"
url:   "/$url"
---
END_FRONTMATTER

    if ( $divs->size ) {
        $target->append_utf8($frontmatter);

        $divs->each(
            sub {
                my $div_content = shift;

                # Extract the inner HTML of the div
                my $inner_html = $div_content->to_string;

                # Remove all tags using HTML::Restrict
                my $hr = HTML::Restrict->new(
                    create_newlines => 1,
                    rules => {
                        a   => [qw( href )],
                        h2 => [],
                        img => [qw( src alt / )],
                        li  => [],
                        ul  => [],
                    }
                );
                my $plain_text = $hr->process($inner_html);

                my $plain_dom = Mojo::DOM->new($plain_text);

                $plain_dom->find('h2')
                    ->each( sub { my $h = shift; $h->replace('## ' . trim($h->content)); } );

                # Convert "a" elements to markdown links
                $plain_dom->find('a')->each(
                    sub {
                        my $a    = shift;
                        my $href = $a->attr('href');
                        my $text = trim( $a->text );
                        if ( !$text ) {
                            my $child = $a->children->first;
                            if ( $child && $child->attr('src') ) {
                                $text = '/images/' . $child->attr('src');

                                # there are things like this:
                                # <a> <img alt="Picture" src="uploads/1/0/6/6/106663517/perl-r-demo_orig.png"></a>
                                if ($href) {
                                    $a->replace("[![Picture]($text)]($href)");
                                }
                                else {
                                    $a->replace("[![Picture]($text)]");
                                }
                                return;
                            }
                            $text = '🤔🤔🤔 ';
                        }
                        $a->replace("[$text]($href)");
                    }
                );

                $plain_dom->find('ul')->each(
                    sub {
                        my $ul = shift;
                        $ul->find('li')->each(
                            sub {
                                my $li = shift;
                                process_li( $li, 0 );
                            }
                        );
                    }
                );

                $plain_text = $plain_dom->all_text;
                my @lines    = map { trim($_) } split m{\n}, $plain_text;
                my $filtered = join "\n", @lines;
                $filtered =~ s{\n{2,}}{\n\n}g;
                $target->append_utf8($filtered);
            }
        );
    }
    else {
        die "No div with class 'wsite-section-content' found in the file.\n";
    }
}

sub process_li {
    my ( $li, $level ) = @_;
    $li->find('ul')->each(
        sub {
            my $ul = shift;
            process_li( $ul, $level + 1 );
        }
    );
    my $content = trim( $li->all_text );
    $li->replace( ' ' x $level . '- ' . $content );

    $li->find('li')->each(
        sub {
            my $nested_li = shift;
            process_li( $nested_li, $level );
        }
    );
}

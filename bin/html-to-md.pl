#!/usr/bin/env perl

use v5.40;

use Mojo::DOM      ();
use Mojo::Util     qw( trim );
use HTML::Restrict ();
use Path::Tiny     qw( path );

# Check if a file name is provided
if ( @ARGV != 1 ) {
    die "Usage: $0 <filename>\n";
}

my $file         = path( $ARGV[0] );
my $html_content = $file->slurp;

# Parse the HTML with Mojo::DOM
my $dom = Mojo::DOM->new($html_content);

# Locate the div with the class 'wsite-section-content'
my $divs        = $dom->find('div.wsite-section-content');
my $title       = $dom->at('title')->text || die 'no title found';
my $frontmatter = <<"END_FRONTMATTER";
---
title: "$title"
---
END_FRONTMATTER

if ( $divs->size ) {
    print "$frontmatter\n";

    $divs->each(
        sub {
            my $div_content = shift;

            # Extract the inner HTML of the div
            my $inner_html = $div_content->to_string;

            # Remove all tags using HTML::Restrict
            my $hr = HTML::Restrict->new(
                rules => {
                    a   => [qw( href )],
                    img => [qw( src alt / )]
                }
            );
            my $plain_text = $hr->process($inner_html);

            my $plain_dom = Mojo::DOM->new($plain_text);

            # Convert "a" elements to markdown links
            $plain_dom->find('a')->each(
                sub {
                    my $a = shift;
                    print $a->content;
                    my $href = $a->attr('href');
                    my $text = trim( $a->text );
                    if ( !$text ) {
                        my $child = $a->children->first;
                        if ( $child && $child->attr('src') ) {
                            $text = '/images/' . $child->attr('src');
                            $a->replace("[![Picture]($text)]($href)");
                            return;
                        }
                        $text = '🤔🤔🤔 ';
                    }
                    $a->replace("[$text]($href)");
                }
            );

            $plain_text = $plain_dom->all_text;
            my @lines = map { trim($_) } split m{\n}, $plain_text;
            print join "\n", @lines;
        }
    );
}
else {
    print "No div with class 'wsite-section-content' found in the file.\n";
}

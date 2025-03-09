#!/usr/bin/env perl

use v5.40;

use Mojo::DOM      ();
use Mojo::Util     qw( trim );
use HTML::Restrict ();
use Path::Iterator::Rule ();
use Path::Tiny     qw( path );

my $rule = Path::Iterator::Rule->new; # match anything
my $next = $rule->iter( 'www.perlfoundation.org' );
while ( defined( my $file = $next->() ) ) {
    if ( $file !~ m{\.html\z} ) {
        next;
    }
    say $file;
    convert_file(path($file));
}


sub convert_file ($file) {
    my $html_content = $file->slurp;
    my $target = path('static/content')->child($file->basename('.html') . '.md');
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
        $target->append($frontmatter);

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
                my @lines    = map { trim($_) } split m{\n}, $plain_text;
                my $filtered = join "\n", @lines;
                $filtered =~ s{\n{2,}}{\n\n}g;
                $target->append($filtered);
            }
        );
    }
    else {
        die "No div with class 'wsite-section-content' found in the file.\n";
    }
}

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
                    rules           => {
                        a      => [qw( href )],
                        h3     => [],
                        img    => [qw( src alt / )],
                        li     => [],
                        strong => [],
                        ul     => [],
                    }
                );
                my $plain_text = $hr->process($inner_html);
                $plain_text =~ s/\x{200B}//g;    # zero width space

                my @lines = map { trim($_) } split "\n", $plain_text;
                $plain_text = join "\n", @lines;

                my $plain_dom = Mojo::DOM->new($plain_text);

                $plain_dom->find('h2')->each(
                    sub {
                        my $h = shift;
                        $h->replace( '## ' . trim( $h->content ) );
                    }
                );

                # strong seems to be used in the same was as a third level heading.
                $plain_dom->find('strong')->each(
                    sub {
                        my $h = shift;
                        $h->replace( "\n### " . trim( $h->content ) );
                    }
                );

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

                replace_html_lists_with_markdown($plain_dom);

                $plain_text = $plain_dom->all_text;
                @lines    = split m{\n}, $plain_text;
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

sub replace_html_lists_with_markdown {
    my $dom = shift;

    # Find all top-level lists (not nested inside other lists)
    my @all_lists = $dom->find('ul, ol')->each;

    # Filter to top-level lists (not contained in other li elements)
    my @top_lists;
    foreach my $list (@all_lists) {

        # Check if this list has any ancestor that's a ul or ol
        my $has_list_ancestor = 0;
        my $parent            = $list->parent;
        while ($parent) {
            if ( $parent->tag
                && ( $parent->tag eq 'ul' || $parent->tag eq 'ol' ) ) {
                $has_list_ancestor = 1;
                last;
            }
            $parent = $parent->parent;
        }

        # If no list ancestor, it's a top-level list
        push @top_lists, $list unless $has_list_ancestor;
    }

    # Replace each top-level list with its markdown equivalent
    foreach my $list (@top_lists) {
        my $markdown = process_list( $list, 0 );

        # Create a text node with the markdown content
        my $markdown_node
            = Mojo::DOM->new->parse("<pre>$markdown</pre>")->at('pre');

        # Replace the list with the markdown
        $list->replace($markdown_node);
    }
}

sub process_list {
    my ( $list, $depth ) = @_;

    my $markdown   = '';
    my $is_ordered = $list->tag eq 'ol';
    my $counter    = 1;

    # Process each list item
    for my $item ( $list->children('li')->each ) {

        # Calculate the prefix based on list type and depth
        my $prefix = '    ' x $depth;
        if ($is_ordered) {
            $prefix .= "$counter. ";
            $counter++;
        }
        else {
            $prefix .= "* ";
        }

        # Extract the text content of the current li (excluding nested lists)
        my $text = '';

        # Process child nodes
        for my $node ( $item->child_nodes->each ) {

            # Skip nested lists - we'll process them separately
            next
                if ref $node
                && ( $node->type eq 'element' )
                && ( $node->tag eq 'ul' || $node->tag eq 'ol' );

            # Add text content or element content
            if ( $node->type eq 'text' ) {
                $text .= $node->content;
            }
            elsif ( $node->type eq 'element' ) {
                $text .= $node->to_string;
            }
        }

        $text =~ s/^\s+|\s+$//g;    # Trim whitespace

        # Add the item text to markdown
        $markdown .= "$prefix$text\n";

        # Process any nested lists
        for my $nested ( $item->children('ul, ol')->each ) {
            $markdown .= process_list( $nested, $depth + 1 );
        }
    }

    return $markdown;
}

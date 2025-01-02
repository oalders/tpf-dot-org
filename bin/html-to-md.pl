#!/usr/bin/env perl
use strict;
use warnings;
use Mojo::DOM      ();
use HTML::Restrict ();

# Check if a file name is provided
if ( @ARGV != 1 ) {
    die "Usage: $0 <filename>\n";
}

my $filename = $ARGV[0];

# Open the file and read its content
open my $fh, '<', $filename or die "Could not open file '$filename': $!\n";
my $html_content = do { local $/; <$fh> };
close $fh;

# Parse the HTML with Mojo::DOM
my $dom = Mojo::DOM->new($html_content);

# Locate the div with the class 'wsite-section-content'
my $divs = $dom->find('div.wsite-section-content');

if ( $divs->size ) {
    $divs->each(
        sub {
            my $div_content = shift;

            # Extract the inner HTML of the div
            my $inner_html = $div_content->to_string;

            # Remove all tags using HTML::Restrict
            my $hr = HTML::Restrict->new(
                rules => { img => [qw( src alt / )] } );
            my $plain_text = $hr->process($inner_html);

            # Print the cleaned content
            print "Extracted Content:\n$plain_text\n";
        }
    );
}
else {
    print "No div with class 'wsite-section-content' found in the file.\n";
}

#!/usr/bin/env perl

use strict ;
use warnings ;

use Text::Xslate ;
my $template = Text::Xslate->new() ;

my @card_suits = qw( yellow_star ) ;

foreach my $card_suit (@card_suits) {
    for( 0 .. 19 ) {
        
        my $digit = $_ ;
        my $rendered_filename = "${card_suit}_${digit}.svg" ;
        open my $rendered_fh, '>', $rendered_filename or die "Couldn't open $rendered_filename $! " ;

        my $template_name = "${card_suit}_single_digit_base.svg.tmpl" ; 
        if( $digit >= 10 && $digit < 100 ) {
            my $template_name = "${card_suit}_double_digit_base.svg.tmpl" ; 
        }
        
        render_card($template_name,
                    $digit,
                    $rendered_fh, ) ;
    }
}
sub render_card {

    my $template_file = shift ;
    my $digit = shift ;
    my $target_fh = shift ; 

    my %vars = (digit => $digit ) ;
    
    print $target_fh $template->render($template_file,
                                       \%vars) ;

}

#!/usr/bin/env perl

use strict ;
use warnings ;

use Text::Xslate ;
my $template = Text::Xslate->new() ;

my @card_suits = qw( yellow_star red_circle) ;

foreach my $card_suit (@card_suits) {
    my $example_html = start_html( $card_suit ) ;
    for( 0 .. 19 ) {
        
        my $digit = $_ ;
        my $rendered_filename = "${card_suit}_${digit}.svg" ;
        open my $rendered_fh, '>', $rendered_filename or die "Couldn't open $rendered_filename $! " ;

        my $template_name = "${card_suit}_single_digit_base.svg.tmpl" ; 
        if( $digit >= 10 && $digit < 100 ) {
            $template_name = "${card_suit}_double_digit_base.svg.tmpl" ; 
        }
        
        render_card($template_name,
                    $digit,
                    $rendered_fh, ) ;

        $example_html
            .= "<p>"
            . create_svg_reference( $rendered_filename )
            . "</p><br />\n" ;
    }

    $example_html .= end_html() ;

    open my $example_html_fh, '>', "${card_suit}.html" or warn "Couldn't create html sample file" ;
    print $example_html_fh $example_html ;
}

sub start_html {

    my $card_suit = shift ;


    my $start_html =<<"EOHTML";
<html>
  <head>
    <title>$card_suit</title>
  </head>
  <body>
    <h1>$card_suit</h1>
EOHTML

    return $start_html ;
}

sub end_html {

    my $end_html =<<"EOHTML";
  </body>
</html>
EOHTML

    return $end_html ;
    
}

sub create_svg_reference {
    
    my $rendered_filename = shift ;

    return qq{<img width="100px" height="100px" src="${rendered_filename}" />} ;
}

sub render_card {

    my $template_file = shift ;
    my $digit = shift ;
    my $target_fh = shift ; 

    my %vars = (digit => $digit ) ;
    
    print $target_fh $template->render($template_file,
                                       \%vars) ;

}

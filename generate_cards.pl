#!/usr/bin/env perl

use strict ;
use warnings ;

use Text::Xslate ;
my $template = Text::Xslate->new() ;

#my @card_suits = qw( yellow_star
#                     red_circle
#                     blue_triangle
#                     brown_rectangle
#                     green_plus
#               ) ;

my @card_suits = ( { color => 'ffff00',
                     color_name => 'yellow',
                     symbol => 'star', }, ) ;
                       
      
foreach my $card_suit_ref (@card_suits) {
    
    my $symbol = $card_suit_ref->{symbol} ;
    my $color = $card_suit_ref->{color} ;
    
    my $card_suit_name = $card_suit_ref->{color_name} . '_' . $symbol ; 

    my $example_html = start_html( $card_suit_ref ) ;


    #    for( 0 .. 19 ) {
    for( 10 .. 19 ) {
        
        my $digit = $_ ;
       
        my $rendered_filename = "generated/${card_suit_name}_${digit}.svg" ;
        open my $rendered_fh, '>', $rendered_filename or die "Couldn't open $rendered_filename $! " ;
        
        my $template_name = "single_digit_${symbol}.tx" ; 
        if( $digit >= 10 && $digit < 100 ) {
            $template_name = "double_digit_${symbol}.tx" ; 
        }
        
        render_card($template_name,
                    $card_suit_ref,
                    $digit,
                    $rendered_fh, ) ;

        $example_html
            .= "<p>"
            . create_svg_reference( $rendered_filename )
            . "</p><br />\n" ;
    }

    $example_html .= end_html() ;

    open my $example_html_fh, '>', "generated/${card_suit_name}.html"
        or warn "Couldn't create html sample file" ;
    print $example_html_fh $example_html ;
}

sub start_html {

    my $card_suit_ref = shift ;


    my $start_html =<<"EOHTML";
<html>
  <head>
    <title>$card_suit_ref->{color_name} $card_suit_ref->{symbol}</title>
  </head>
  <body>
    <h1>$card_suit_ref->{color_name} $card_suit_ref->{symbol}</h1>
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
    my $card_suit_ref = shift ;
    my $digit = shift ;
    my $target_fh = shift ; 

    my %vars = (digit => $digit,
                color => $card_suit_ref->{color},
            ) ;
    
    print $target_fh $template->render($template_file,
                                       \%vars) ;
    
}

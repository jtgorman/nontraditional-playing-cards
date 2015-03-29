#!/usr/bin/env perl

use strict ;
use warnings ;

use Text::Xslate qw( mark_raw );
my $template = Text::Xslate->new() ;

use Getopt::Long ;

my $base = 'base' ;

my $use_guides = 0 ;
GetOptions('use-guides' => \$use_guides,
           'with-guides' => \$use_guides,
       ) ;

if($use_guides) {
    print "Using guideboxes around suit symbols\n" ;
    $base = 'base_guides' ;
}

#my @card_suits = qw( yellow_star
#                     red_circle
#                     blue_triangle
#                     brown_rectangle
#                     green_plus
#               ) ;

my @card_suits = ( { color => 'ffff00',
                     color_name => 'yellow',
                     symbol => 'star', },
                   { color => 'ff0000',
                     color_name => 'red',
                     symbol => 'circle', },
                   );

foreach my $card_suit_ref (@card_suits) {
    
    my $symbol = $card_suit_ref->{symbol} ;
    my $color = $card_suit_ref->{color} ;
    
    my $card_suit_name = $card_suit_ref->{color_name} . '_' . $symbol ; 
    
    my $example_html = start_html( $card_suit_ref ) ;
        
    for( 0 .. 19 ) {
        
        my $digit = $_ ;
        
        my $rendered_filename = "${card_suit_name}_${digit}.svg" ;
        open my $rendered_fh, '>','generated/' . $rendered_filename or die "Couldn't open generated/${rendered_filename} $! " ;
        
        my $template_name = "single_digit_${base}.tx" ; 
        if( $digit >= 10 && $digit < 100 ) {
            $template_name = "double_digit_${base}.tx" ; 
        }

        my $symbol_svg = render_symbol( $symbol . q{.tx},
                                        $card_suit_ref, ) ;

        
        render_card($template_name,
                    $card_suit_ref,
                    $symbol_svg,
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

sub render_symbol {

    my $template_file = shift ;
    my $card_suit_ref = shift ;
    
    my %vars = ( color => $card_suit_ref->{color}, ) ;

    my $symbol_template = Text::Xslate->new() ;
        
    my $svg_text =  $symbol_template->render($template_file,
                                             \%vars ) ;
    return $svg_text ;
}

sub render_card {
    
    my $template_file = shift ;
    my $card_suit_ref = shift ;
    my $symbol_svg = shift ;
    my $digit = shift ;
    my $target_fh = shift ; 

    my %vars = (digit => $digit,
                color => $card_suit_ref->{color},
                symbol_svg => mark_raw( $symbol_svg ),
            ) ;
    
    print $target_fh $template->render($template_file,
                                       \%vars) ;
    
}

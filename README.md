This is a set of cards that I can use for creating epub version of rules for games that are a little bit more device friendly. Intended for games where there are non-traditional suits.

They were initially created in Inkscape, although the green plus comes from a wikipedia file (http://en.wikipedia.org/wiki/File:Plus%2B.svg)

Font is Source Code Pro, from https://github.com/adobe-fonts/source-code-pro.

I tinkered around with a base file to get the general look and feel of 1s and 10s of each suit and then used Text::Xslate templates to generate different cards.

Generating:

./generate_cards.pl

TODOs:
* need to research how many svg renders in epub software support defs + xlink


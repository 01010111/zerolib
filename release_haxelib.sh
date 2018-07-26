#!/bin/sh
rm -f zerolib.zip
zip -r zerolib.zip zero *.md *.json *.hxml run.n
haxelib submit zerolib.zip $HAXELIB_PWD --always
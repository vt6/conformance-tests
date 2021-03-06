#!/usr/bin/env perl

use strict;
use warnings;
use v5.20;

# TODO: more test-cases

say <<'EOF';
# NOTE: See README.md in this directory for syntax explanation.

# minimal examples
test (want)
ok   (want)

test (want () ())
ok   (want () ())

test (want (()))
ok   (want (()))

test (want bar)
ok   (want bar)

# whitespaces!
test (want  \x0A\x0C    )
ok   (want)

test (want  ( ) ( )  )
ok   (want () ())
test (want  ( ( ) )  )
ok   (want (()))

test (   \x09\x0Awant\x0Cbar\x0Dfoo    )
ok   (want bar foo)

# what's allowed in barewords
test (want 0 3.0 bareword example-bareword example3.0)
ok   (want 0 3.0 bareword example-bareword example3.0)

# barewords are equivalent to quoted strings, and shortest encoding prefers barewords over quoted strings
test (want "0" "3.0" "bareword" "example-bareword" "example3.0")
ok   (want 0 3.0 bareword example-bareword example3.0)

# no whitespace required between barewords and quoted strings
test (want 0"3.0"bareword"example-bareword"example3.0)
ok   (want 0 3.0 bareword example-bareword example3.0)

# no whitespace required between quoted strings
test (want "0""3.0""bareword""example-bareword""example3.0")
ok   (want 0 3.0 bareword example-bareword example3.0)

# quoted strings
test (want "string with \"quotes\"")
ok   (want "string with \"quotes\"")
test (want "string with \\back\\slashes")
ok   (want "string with \\back\\slashes")

# quoted strings allow UTF-8
test (want "¯\\_(ツ)_/¯")
ok (want "¯\\_(ツ)_/¯")

# errors when parsing S-expressions
test  a(want foo bar)
error 0 invalid start of S-expression

test  (want (foo)
error 11 unexpected EOF in S-expression

# autogenerated tests for each character
EOF

sub escape_char {
  my ($char) = @_;
  my $ord = ord($char);
  # printable characters don't need escaping
  return ($ord >= 32 && $ord < 127) ? $char : sprintf('\x%02X', $ord);
}

sub is_whitespace {
  my ($char) = @_;
  my $ord = ord($char);
  return $ord == 0x20 || ($ord >= 0x09 && $ord <= 0x0D);
}

sub is_bareword { $_[0] =~ /[a-zA-Z0-9._-]/ }

sub is_high { ord($_[0]) >= 128 }

for my $ord (0..255) {
  my $char = chr($ord);
  my $escaped = escape_char($char);

  say "test (want $escaped)";
  if (is_bareword($char)) {
    say "ok (want $escaped)";
  } elsif (is_whitespace($char)) {
    say "ok (want)";
  } elsif ($char eq '(') {
    say 'error 8 unexpected EOF in S-expression';
  } elsif ($char eq ')') {
    say 'error 7 expected EOF';
  } elsif ($char eq '"') {
    say 'error 8 unexpected EOF in quoted string';
  } else {
    say 'error 6 invalid start of atom';
  }

  say "test (want \"$escaped\")";
  if ($char eq '\\' or $char eq '"') {
    say 'error 10 unexpected EOF in quoted string';
  } elsif (is_high($char)) {
    say 'error 7 invalid UTF-8';
  } else {
    if (is_bareword($char)) {
      say "ok (want $char)";
    } else {
      say "ok (want \"$escaped\")";
    }
  }

  say "test (want \"a\\${escaped}b\")";
  if ($char eq '\\' or $char eq '"') {
    say "ok (want \"a\\${char}b\")";
  } else {
    say 'error 8 invalid escape sequence';
  }
}

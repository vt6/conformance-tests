# Tests for `vt6/core`

## `message-parsing.txt`

This file contains test cases for parsing and serializing S-expressions and messages as defined in <https://vt6.io/std/core/1.0/#section-2>.
It is generated by `message-parsing.txt.pl`.

Empty lines and comment lines starting with `#` are to be ignored.
Each other line has one of the following formats:

* `test <arg>` starts a new testcase.
  The `<arg>` is the message to parse. It may contain 2-digit hexadecimal escape sequence to encode arbitrary bytes, esp. ASCII control characters, e.g. `\x0A` for NL.
* `ok <arg>` indicates that the current testcase is a valid message.
  The test MUST fail if the implementation produces an error while parsing this message
  The `<arg>` is a pretty-printed representation of an equivalent message with no superfluous whitespace, except for one space between each element of an S-expression.
  Implementations MUST check that parsing this string succeeds and produces a message that is semantically equivalent to the one that was parsed in this testcase.
  Implementations that can serialize messages SHOULD check whether they produce the same string when serializing the message that was parsed in this testcase.
* `error <offset> <msg>` indicates that the current testcase is an invalid message.
  The test MUST fail if the implementation produces *no* error while parsing this message.
  The first argument `<offset>` indicates at which byte offset the parse error occurred. The test SHOULD check whether it reports the same error location.
  The `<argument>` is a human-readable error message indicating the reason while this testcase fails to parse or validate.
  The test SHOULD check whether it produces the same error message.
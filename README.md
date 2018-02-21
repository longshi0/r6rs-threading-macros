Arrow/Wand Threading Macros for R6RS
====================================

This is a set of macros meant to improve the readabilty of Scheme code by
changing the apparent procedure application order. This is especially helpful
e.g. for math expressions or object-oriented code.

### Arrows
(**~>** *val* expr exprs ...)

Insert val as the second item in expr and subsequently as the second item in each exprs ...

**N.B.** lambda expressions must be enclosed within an extra set of parens.

```scheme
(~> 3 (* 10) (/ 2) ((lambda (x) (- x 14))))
; => 1
```

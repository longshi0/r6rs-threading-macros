Arrow/Wand Threading Macros for R6RS
====================================

This is a set of macros meant to improve the readabilty of Scheme code by
changing the apparent procedure application order (which is especially helpful
e.g. for math expressions or object-oriented code).

**N.B.** when threading lambda expressions, they must be enclosed within an extra set of parens.

## Arrows
(**~>** *val expr exprs ...*)

Insert *val* subsequently as the second item in each *exprs ...*

```scheme
(~> 3
    (* 10)
    (/ 2)
    ((lambda (x) (- x 14))))
; => 1
```
---
(**~>>** *val exprs ...*)

Insert *val* subsequently as the last item in each *exprs ...*

```scheme
(~>> 100
    (< 1 10)
    (or #f)
    ((lambda (x) (if x 'foo 'bar))))
; => foo
```
---

## Wands
(**~<>** *val exprs ...*)

Insert *val* wherever the symbol **<>** appears in each *exprs ...* form.

```scheme
(~<> 50
     (< 1 <> 100)
     (and <> <>)
     (if <> 'foo 'bar))
; => foo
```
---

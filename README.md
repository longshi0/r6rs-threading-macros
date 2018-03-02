Arrow/Wand Threading Macros for R6RS
====================================

This is a set of macros meant to improve the readabilty of Scheme code by
changing the apparent procedure application order (which is especially helpful
e.g. for math expressions or object-oriented code).

Threading macros evaluate the body of their leftmost form and insert the result
into a specific location in the next leftmost form. If the next leftmost form is
a symbol that would evaluate to a procedure, it is applied to the result of the
previous form.

The wand macros allow you to specify this location explicitly. Macros whose
names begin with `some-` are short-circuiting versions that will abort if any
form evaluates to `#f`.

#### Caveats:
* when threading lambda expressions, they must be enclosed within an extra set
  of parens (eg `((lambda (x) x))`).
* be mindful that quoted symbols (eg `'foo`), which appear to be atoms, expand
  to `(quote foo)`

## (import (threading))
(**~>** *init-expr [forms ...]*)

Thread *init-expr* as the subsequent second item in each of the *forms*

```scheme
(~> 3 (* 10) (/ 2) (- 5))
; => 10
```
---
(**~>>** *init-expr [forms ...]*)

Thread *init-expr* as the subsequent last item in each  of the *forms*.

```scheme
(~>> 100
    (< 1 10)
    (or #f)
    ((lambda (x) (if x 'foo 'bar))))
; => foo
```
---
(**~<>** *init-expr [forms ...]*)

Thread *init-expr* subsequently wherever the symbol `<>` appears (multiple
occurrences allowed) in each of the *forms*. If no `<>` appears in a form,
behavior defaults to `~>`.

```scheme
(~<> (add1 1)
     (< 1 <> 100)
     (and #t)
     (if <> 'foo 'bar))
; => foo
```
---
(**~<>>** *init-expr [forms ...]*)

Thread *init-expr* subsequently wherever the symbol `<>` appears (multiple
occurrences allowed) in each of the *forms*. If no `<>` appears in a form,
behavior defaults to `~>>`.

---
(**some~>** *init-expr [forms ...]*)

The same behavior as `~>` except that if any form evaluates to `#f`, abort the
sequence.

```scheme
(some~> 1 zero? (error "This exception will never be raised"))
; => #f
```
---
(**some~>>** *init-expr [forms ...]*)

The same behavior as `~>>` except that if any form evaluates to `#f`, abort the
sequence.

---
(**some~<>** *init-expr [forms ...]*)

The same behavior as `~<>` except that if any form evaluates to `#f`, abort the
sequence.

---
(**some~>>** *init-expr [forms ...]*)

The same behavior as `~<>>` except that if any form evaluates to `#f`, abort the
sequence.

---

#!r6rs
(library (threading arrows)
  (export ~> ~>>)
  (import (rnrs))

  (define-syntax ~>
    (syntax-rules ()
      ((_ val (f expr ...)) (f val expr ...))
      ((_ val (f expr ...) exprs ...) (~> (f val expr ...) exprs ...))
      ((_ val f) (f val))
      ((_ val f expr ...) (~> (f val) expr ...))))

  (define-syntax ~>>
    (syntax-rules ()
      ((_ val (f expr ...)) (f expr ... val))
      ((_ val (f expr ...) exprs ...) (~>> (f expr ... val) exprs ...))
      ((_ val f) (f val))
      ((_ val f expr ...) (~>> (f val) expr ...))))
  )

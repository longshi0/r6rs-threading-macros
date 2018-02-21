#!r6rs
(library (threading wands)
  (export <> ~<>)
  (import (rnrs))

  (define-syntax <>
    (lambda (x) (syntax-violation '<> "misplaced aux keyword" x)))

  (define-syntax ~<>*
    (lambda (x)
      (syntax-case x ()
        ((_ init (expr exprs ...))
          (let loop ((a #'expr) (d #'(exprs ...)))
            (let ((a^ (if (and (identifier? a) (free-identifier=? a #'<>))
                        #'init
                        a)))
              (if (null? d)
                (list a^)
                (cons a^ (loop (car d) (cdr d)))))))
        ((_ init f) #'(f init)))))

  (define-syntax ~<>
    (syntax-rules ()
      ((_ init) init)
      ((_ init e0 e1 ...) (~<> (~<>* init e0) e1 ...))))
  )

#!r6rs
(library (threading wands)
  (export <> ~<>)
  (import (rnrs))

  (define-syntax <>
    (lambda (x) (syntax-violation '<> "misplaced aux keyword" x)))

  (define-syntax ~<>*
    (lambda (x)
      (syntax-case x ()
        ((_ val (expr exprs ...))
          (let loop ((a #'expr) (d #'(exprs ...)))
            (let ((a^ (if (and (identifier? a) (free-identifier=? a #'<>))
                        #'val
                        a)))
              (if (null? d)
                (list a^)
                (cons a^ (loop (car d) (cdr d)))))))
        ((_ val f) #'(f val)))))

  (define-syntax ~<>
    (syntax-rules ()
      ((_ val) val)
      ((_ val e0 e1 ...) (~<> (~<>* val e0) e1 ...))))
  )

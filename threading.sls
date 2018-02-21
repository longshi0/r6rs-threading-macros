#!r6rs
(library (threading)
  (export ~> ~>> <> ~<>)
  (import (rnrs))

(define-syntax ~>
  (lambda (stx)
    (syntax-case stx ()
      ((_ init) #'init)
      ((_ init form)
        (syntax-case #'form ()
          ((f f1 ...) #'(f init f1 ...))
          (f #'(if (procedure? f) (f init) f))))
      ((_ init form forms ...) #'(~> (~> init form) forms ...)))))

(define-syntax ~>>
  (lambda (stx)
    (syntax-case stx ()
      ((_ init) #'init)
      ((_ init form)
        (syntax-case #'form ()
          ((f f1 ...) #'(f f1 ... init))
          (f #'(if (procedure? f) (f init) f))))
      ((_ init form forms ...) #'(~>> (~>> init form) forms ...)))))

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
        ((_ init f) #'(if (procedure? f) (f init) f)))))

  (define-syntax ~<>
    (syntax-rules ()
      ((_ init) init)
      ((_ init e0 e1 ...) (~<> (~<>* init e0) e1 ...))))
  )

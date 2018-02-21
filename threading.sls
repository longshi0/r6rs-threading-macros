#!r6rs
(library (threading)
  (export ~> ~>> <> ~<>)
  (import (rnrs))

  (define-syntax ~>
    (syntax-rules ()
      ((_ init (f expr ...)) (f init expr ...))
      ((_ init (f expr ...) exprs ...) (~>> (f init expr ... ) exprs ...))
      ((_ init x) (if (procedure? x) (x init) x))
      ((_ init x expr ...) (~> (~> init x) expr ...))))

  (define-syntax ~>>
    (syntax-rules ()
      ((_ init (f expr ...)) (f expr ... init))
      ((_ init (f expr ...) exprs ...) (~>> (f expr ... init) exprs ...))
      ((_ init x) (if (procedure? x) (x init) x))
      ((_ init x expr ...) (~>> (~>> init x) expr ...))))

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

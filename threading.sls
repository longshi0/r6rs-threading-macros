#!r6rs
(library (threading)
  (export ~> ~>> some~> some~>> <> ~<>)
  (import (rnrs))

  (define-syntax ~?
    (lambda (x)
      (syntax-case x ()
        ((_ pred init form)
          (pair? (syntax->datum #'form))
          (syntax-case #'form (before after)
            ((f f1 ...)
              (identifier? #'pred)
              (cond
                ((free-identifier=? #'pred #'before) #'(f init f1 ...))
                ((free-identifier=? #'pred #'after) #'(f f1 ... init))))))
        ((_ _ init form)
          #'(if (procedure? form) (form init) form)))))

  (define-syntax define-arrow
    (lambda (x)
      (syntax-case x ()
        ((_ arr where some?)
          (boolean? (syntax->datum #'some?))
          #'(define-syntax arr
             (lambda (x)
               (syntax-case x ()
                  ((_ init) #'init)
                  ((_ init form) #'(~? where init form))
                  ((_ init form forms (... ...))
                    (if (syntax->datum #'some?)
                      #'(let ((i (arr init form))) (if i (arr i forms (... ...)) #f))
                      #'(let ((i (arr init form))) (arr i forms (... ...))))))))))))

  (define-arrow ~> before #f)

  (define-arrow ~>> after #f)

  (define-arrow some~> before #t)

  (define-arrow some~>> after #t)

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

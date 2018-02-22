;; MIT License
;;
;; Copyright (c) 2018 Joseph Eib
;;
;; Permission is hereby granted, free of charge, to any person obtaining a copy
;; of this software and associated documentation files (the "Software"), to deal
;; in the Software without restriction, including without limitation the rights
;; to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
;; copies of the Software, and to permit persons to whom the Software is
;; furnished to do so, subject to the following conditions:
;;
;; The above copyright notice and this permission notice shall be included in all
;; copies or substantial portions of the Software.
;;
;; THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
;; IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
;; FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
;; AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
;; LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
;; OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
;; SOFTWARE.

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

#!/usr/bin/env scheme-script
(import (scheme) (threading))

(define (test-~>)
  (format #t "Testing ~~>...")
  (assert
    (~> 2
      (+ 2)
      add1
      ((lambda (x) (/ x 5)))
      sub1
      zero?))
  (assert
    (= (~> 1) 1))
  (assert
    (= (~> 1 2) 2))
  (format #t "OK\n"))

(define (test-~>>)
  (format #t "Testing ~~>>...")
  (assert
    (eq? 'foo (~>> 100
               (< 1 10)
               (or #f)
               ((lambda (x) (if x 'foo 'bar))))))
  (assert
    (= (~>> 1) 1))
  (assert
    (= (~>> 1 2) 2))
  (format #t "OK\n"))

(define (test-~<>)
  (format #t "Testing ~~<>...")
  (assert
    (eq? 'foo (~<> (add1 1)
                (< 1 <> 100)
                (and <> <>)
                (if <> 'foo 'bar))))
  (assert
    (= (~<> 1) 1))
  (assert
    (= (~<> 1 2) 2))
  (format #t "OK\n"))

(test-~>)
(test-~>>)
(test-~<>)
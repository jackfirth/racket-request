#lang racket

(require "main.rkt")

(provide
 current-requester
 with-requester
 (rename-out [param-get get]
             [param-put put]
             [param-post post]
             [param-delete delete])
 (except-out (all-from-out "main.rkt") get put post delete))


(define current-requester (make-parameter http-requester))

(define-syntax-rule (with-requester requester body ...)
  (parameterize ([current-requester requester]) body ...))

(define (param-get location #:headers [headers '()])
  (get (current-requester) location #:headers headers))

(define (param-put location body #:headers [headers '()])
  (put (current-requester) location body #:headers headers))

(define (param-post location body #:headers [headers '()])
  (post (current-requester) location body #:headers headers))

(define (param-delete location #:headers [headers '()])
  (delete (current-requester) location #:headers headers))

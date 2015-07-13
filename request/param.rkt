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

(define (param-get location)
  (get (current-requester) location))

(define (param-put location body)
  (put (current-requester) location body))

(define (param-post location body)
  (post (current-requester) location body))

(define (param-delete location)
  (delete (current-requester) location))
